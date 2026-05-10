# Modelado en Promela de `concurrente.go`

Este documento describe **únicamente** el modelo Promela en `algos/recomendation/concurrente.pml` y su relación con **`algos/recomendation/concurrente.go`**. No se modelan otros programas.

El modelo abstrae la concurrencia de la función `main` de `concurrente.go` y se puede verificar con SPIN. Las propiedades que interesan aquí son las que el propio `.pml` expresa: aserciones sobre índices y completitud, y la ausencia de estados finales inválidos (deadlock) en el espacio de estados acotado.

## Parámetros del modelo

En `concurrente.go` el número de workers, el tamaño de buffer de los canales y el número de filas son datos del entorno o del CSV. En Promela se fijan constantes para que el espacio de estados sea manejable:

| Constante | Valor en `.pml` | Rol |
|-----------|-----------------|-----|
| `ROWS` | 4 | Número de filas a procesar (abstrae las filas leídas del CSV en Go). |
| `WORKERS` | 2 | Tamaño del pool de workers (análogo a `numWorkers` en Go). |
| `BUF` | 2 | Capacidad de los canales `jobs` y `results` (en Go los buffers son mayores). |
| `SENTINEL` | -1 | Modela el cierre de `jobs` (`close(jobs)`): un centinela por worker. |

## Qué fragmentos de `concurrente.go` se modelan

**Pool de workers con `WaitGroup`:**

```go
var workers sync.WaitGroup
workers.Add(numWorkers)
for i := 0; i < numWorkers; i++ {
    go func() {
        defer workers.Done()
        for job := range jobs {
            processRow(job.Row, stopwords, lemmas)
            results <- job
        }
    }()
}
```

**Cierre de `results` tras esperar a los workers:**

```go
go func() {
    workers.Wait()
    close(results)
}()
```

**Feeder: índices y cierre de `jobs`:**

```go
go func() {
    defer feeder.Done()
    idx := 0
    for {
        row, err := reader.Read()
        if err == io.EOF { break }
        if err != nil { continue }
        jobs <- RowJob{Index: idx, Row: append([]string(nil), row...)}
        idx++
    }
    close(jobs)
}()
```

**Recolector con reordenado, mutex y escritura (modelado como invariantes sobre `pending` / `nextExpected` / `processed`):**

```go
pending := make(map[int][]string)
nextExpected := 0
processed := 0
var orderMu sync.Mutex
for r := range results {
    orderMu.Lock()
    pending[r.Index] = r.Row
    for {
        row, ok := pending[nextExpected]
        if !ok { break }
        delete(pending, nextExpected)
        if err := writer.Write(withoutLinkColumn(row)); err != nil {
            orderMu.Unlock()
            panic(err)
        }
        nextExpected++
        processed++
    }
    orderMu.Unlock()
}
```

En el `.pml`, `processRow` no se detalla: el worker solo reenvía el índice. La lectura del CSV, la carga de stopwords/lemas y el contenido de cada fila quedan fuera del modelado porque no añaden ramas concurrentes relevantes para este esqueleto.

## Exclusión mutua en este modelado

En Go, `orderMu` protege la sección crítica formada por actualizar `pending`, avanzar `nextExpected`, incrementar `processed` y llamar a `writer.Write`. En Promela eso se representa con la variable global `mtx`: valor **1** = mutex libre, **0** = tomado. El consumer hace:

- adquisición: `atomic { mtx == 1 -> mtx = 0 }` antes de tocar `written[]` y la lógica de `next` / `processed`;
- liberación: `atomic { mtx = 1 }` al salir de esa región.

Así, el modelo documenta explícitamente la coordinación por mutex del recolector de `concurrente.go`, además de la sincronización por canales.

## Sincronización (canales y contadores)

- Los canales `jobs` y `results` modelan los canales con buffer entre feeder, workers y recolector.
- Los centinelas `SENTINEL` modelan el fin del stream en `jobs` para cada worker.
- `done_workers` se incrementa de forma atómica al terminar cada worker; junto con `len(results) == 0` permite expresar la condición de terminación análoga a haber cerrado `results` y drenar el canal.

## Aserciones en `concurrente.pml`

| # | Assertion / chequeo SPIN | Qué indicaría si fallara |
|---|--------------------------|---------------------------|
| 1 | `idx >= 0 && idx < ROWS` al recibir | Índice inválido en el canal `results`. |
| 2 | `processed == ROWS` al final | No se completó el conteo de filas del modelo. |
| 3 | `next == ROWS` al final | El reordenado no consumió toda la secuencia esperada. |
| 4 | `invalid end states` (activo por defecto en `./pan`) | Posible deadlock o terminación inválida del sistema de procesos. |

## Correspondencia `concurrente.go` ↔ fragmentos del `.pml`

| Go | Promela (idea) |
|----|----------------|
| `make(chan RowJob, …)` | `chan jobs` y `chan results` con capacidad `BUF`; el trabajo se abstrae al índice `int`. |
| `close(jobs)` | El feeder envía `WORKERS` veces el valor `SENTINEL`. |
| `for job := range jobs` | Bucle del worker con recepción y `break` al ver `SENTINEL`. |
| `sync.WaitGroup` de workers | `done_workers` incrementado en bloque `atomic` al terminar cada worker. |
| Cierre de `results` tras `Wait()` | Salida del consumer cuando `done_workers == WORKERS` y `len(results) == 0`. |
| `pending` / `nextExpected` | `written[]` y `next` con la misma idea de reordenado. |
| `orderMu` | `mtx` con adquisición y liberación atómicas alrededor de la sección crítica del consumer. |
| `processRow` | Passthrough: el worker reenvía el índice. |

## Verificación con SPIN

Desde `algos/recomendation`:

```bash
spin -a concurrente.pml
cc -o pan pan.c
./pan
```

Una corrida reciente con el modelo actual mostró `errors: 0`, búsqueda con `invalid end states +` y del orden de **~26 000–27 000** estados almacenados (depende de la versión exacta del `.pml` y de SPIN).

Comandos útiles durante el ajuste del modelo:

```bash
spin concurrente.pml
spin -c concurrente.pml
rm -f pan pan.c pan.b pan.h pan.m pan.t pan.p
```

Al subir `ROWS`, `WORKERS` o `BUF`, el espacio de estados crece rápidamente; puede hacer falta ajustar memoria o profundidad (`./pan -h`).
