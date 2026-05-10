/*
 * Modelo Promela del unico programa fuente: algos/recomendation/concurrente.go
 * (no modela otros archivos ni otros pipelines del repositorio).
 *
 * Mapeo respecto al codigo Go:
 *   Feeder()    <-> goroutine que lee CSV y envia RowJob a `jobs`
 *   Worker()    <-> pool de workers que procesan filas y envian a `results`
 *   Consumer()  <-> goroutine main que reordena por indice y escribe
 *
 * Simplificaciones:
 *   - processRow (stopwords/lemas) se reemplaza por passthrough.
 *   - El cierre de canal de Go se modela enviando un centinela (-1)
 *     una vez por cada worker.
 *   - El WaitGroup se modela con un contador atomico done_workers.
 *   - El map `pending` + `nextExpected` se modela con un arreglo
 *     `written[ROWS]` y la variable `next`.
 *   - sync.Mutex `orderMu` (Go) se modela con `mtx`: 1 = libre, 0 = tomado.
 */

#define ROWS     4
#define WORKERS  2
#define BUF      2     /* tamano de buffer de los canales jobs y results */
#define SENTINEL -1

chan jobs    = [BUF] of { int };
chan results = [BUF] of { int };

byte done_workers = 0;
bool written[ROWS];
byte next = 0;
byte mtx = 1;   /* mutex: 1 libre, 0 en seccion critica */

active proctype Feeder() {
    int i;
    int k;
    i = 0;
    do
    :: i < ROWS  -> jobs ! i; i++
    :: i == ROWS -> break
    od;
    /* equivale a close(jobs) en Go: un centinela por worker */
    k = 0;
    do
    :: k < WORKERS  -> jobs ! SENTINEL; k++
    :: k == WORKERS -> break
    od
}

proctype Worker() {
    int idx;
    do
    :: jobs ? idx ->
        if
        :: idx == SENTINEL -> break
        :: else            -> results ! idx   /* "procesar" = passthrough */
        fi
    od;
    atomic { done_workers++ }
}

active proctype Consumer() {
    int idx;
    byte processed;
    processed = 0;
    do
    :: results ? idx ->
        atomic { mtx == 1 -> mtx = 0 }
        assert(idx >= 0 && idx < ROWS);
        written[idx] = true;
        /* reordenado: avanzamos `next` mientras la fila ya este escrita.
         * Asi se respeta orden estricto de salida (como el map `pending`
         * + `nextExpected` del codigo Go). */
        do
        :: next < ROWS && written[next] -> next++; processed++
        :: else -> break
        od
        atomic { mtx = 1 }
    :: atomic { done_workers == WORKERS && len(results) == 0 -> break }
    od;
    assert(processed == ROWS);
    assert(next == ROWS);
}

init {
    int w;
    w = 0;
    do
    :: w < WORKERS  -> run Worker(); w++
    :: w == WORKERS -> break
    od
}
