#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC :init: */
	case 3: // STATE 1 - concurrente.pml:86 - [w = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[3][1] = 1;
		(trpt+1)->bup.oval = ((P3 *)_this)->w;
		((P3 *)_this)->w = 0;
#ifdef VAR_RANGES
		logval(":init::w", ((P3 *)_this)->w);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - concurrente.pml:88 - [((w<2))] (0:0:0 - 1)
		IfNotBlocked
		reached[3][2] = 1;
		if (!((((P3 *)_this)->w<2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - concurrente.pml:88 - [(run Worker())] (0:0:0 - 1)
		IfNotBlocked
		reached[3][3] = 1;
		if (!(addproc(II, 1, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - concurrente.pml:88 - [w = (w+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[3][4] = 1;
		(trpt+1)->bup.oval = ((P3 *)_this)->w;
		((P3 *)_this)->w = (((P3 *)_this)->w+1);
#ifdef VAR_RANGES
		logval(":init::w", ((P3 *)_this)->w);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 5 - concurrente.pml:89 - [((w==2))] (0:0:1 - 1)
		IfNotBlocked
		reached[3][5] = 1;
		if (!((((P3 *)_this)->w==2)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: w */  (trpt+1)->bup.oval = ((P3 *)_this)->w;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P3 *)_this)->w = 0;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 10 - concurrente.pml:91 - [-end-] (0:0:0 - 3)
		IfNotBlocked
		reached[3][10] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Consumer */
	case 9: // STATE 1 - concurrente.pml:64 - [processed = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->processed);
		((P2 *)_this)->processed = 0;
#ifdef VAR_RANGES
		logval("Consumer:processed", ((int)((P2 *)_this)->processed));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 2 - concurrente.pml:66 - [results?idx] (0:0:1 - 1)
		reached[2][2] = 1;
		if (q_len(now.results) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((P2 *)_this)->idx;
		;
		((P2 *)_this)->idx = qrecv(now.results, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Consumer:idx", ((P2 *)_this)->idx);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.results);
		sprintf(simtmp, "%d", ((P2 *)_this)->idx); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 11: // STATE 3 - concurrente.pml:67 - [((mtx==1))] (7:0:1 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		if (!((((int)now.mtx)==1)))
			continue;
		/* merge: mtx = 0(7, 4, 7) */
		reached[2][4] = 1;
		(trpt+1)->bup.oval = ((int)now.mtx);
		now.mtx = 0;
#ifdef VAR_RANGES
		logval("mtx", ((int)now.mtx));
#endif
		;
		/* merge: assert(((idx>=0)&&(idx<4)))(7, 6, 7) */
		reached[2][6] = 1;
		spin_assert(((((P2 *)_this)->idx>=0)&&(((P2 *)_this)->idx<4)), "((idx>=0)&&(idx<4))", II, tt, t);
		_m = 3; goto P999; /* 2 */
	case 12: // STATE 7 - concurrente.pml:69 - [written[idx] = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[2][7] = 1;
		(trpt+1)->bup.oval = ((int)now.written[ Index(((P2 *)_this)->idx, 4) ]);
		now.written[ Index(((P2 *)_this)->idx, 4) ] = 1;
#ifdef VAR_RANGES
		logval("written[Consumer:idx]", ((int)now.written[ Index(((P2 *)_this)->idx, 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 8 - concurrente.pml:74 - [(((next<4)&&written[next]))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][8] = 1;
		if (!(((((int)now.next)<4)&&((int)now.written[ Index(((int)now.next), 4) ]))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 9 - concurrente.pml:74 - [next = (next+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[2][9] = 1;
		(trpt+1)->bup.oval = ((int)now.next);
		now.next = (((int)now.next)+1);
#ifdef VAR_RANGES
		logval("next", ((int)now.next));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 10 - concurrente.pml:74 - [processed = (processed+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[2][10] = 1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->processed);
		((P2 *)_this)->processed = (((int)((P2 *)_this)->processed)+1);
#ifdef VAR_RANGES
		logval("Consumer:processed", ((int)((P2 *)_this)->processed));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 16 - concurrente.pml:77 - [mtx = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[2][16] = 1;
		(trpt+1)->bup.oval = ((int)now.mtx);
		now.mtx = 1;
#ifdef VAR_RANGES
		logval("mtx", ((int)now.mtx));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 18 - concurrente.pml:78 - [(((done_workers==2)&&(len(results)==0)))] (25:0:0 - 1)
		IfNotBlocked
		reached[2][18] = 1;
		if (!(((((int)now.done_workers)==2)&&(q_len(now.results)==0))))
			continue;
		/* merge: goto :b3(25, 19, 25) */
		reached[2][19] = 1;
		;
		/* merge: assert((processed==4))(25, 24, 25) */
		reached[2][24] = 1;
		spin_assert((((int)((P2 *)_this)->processed)==4), "(processed==4)", II, tt, t);
		_m = 3; goto P999; /* 2 */
	case 18: // STATE 24 - concurrente.pml:80 - [assert((processed==4))] (0:25:0 - 2)
		IfNotBlocked
		reached[2][24] = 1;
		spin_assert((((int)((P2 *)_this)->processed)==4), "(processed==4)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 19: // STATE 25 - concurrente.pml:81 - [assert((next==4))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][25] = 1;
		spin_assert((((int)now.next)==4), "(next==4)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 20: // STATE 26 - concurrente.pml:82 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][26] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Worker */
	case 21: // STATE 1 - concurrente.pml:52 - [jobs?idx] (0:0:1 - 1)
		reached[1][1] = 1;
		if (q_len(now.jobs) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((P1 *)_this)->idx;
		;
		((P1 *)_this)->idx = qrecv(now.jobs, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Worker:idx", ((P1 *)_this)->idx);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.jobs);
		sprintf(simtmp, "%d", ((P1 *)_this)->idx); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 22: // STATE 2 - concurrente.pml:54 - [((idx==-(1)))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!((((P1 *)_this)->idx== -(1))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: idx */  (trpt+1)->bup.oval = ((P1 *)_this)->idx;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->idx = 0;
		_m = 3; goto P999; /* 0 */
	case 23: // STATE 5 - concurrente.pml:55 - [results!idx] (0:0:0 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		if (q_full(now.results))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.results);
		sprintf(simtmp, "%d", ((P1 *)_this)->idx); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.results, 0, ((P1 *)_this)->idx, 1);
		_m = 2; goto P999; /* 0 */
	case 24: // STATE 11 - concurrente.pml:58 - [done_workers = (done_workers+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][11] = 1;
		(trpt+1)->bup.oval = ((int)now.done_workers);
		now.done_workers = (((int)now.done_workers)+1);
#ifdef VAR_RANGES
		logval("done_workers", ((int)now.done_workers));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 25: // STATE 13 - concurrente.pml:59 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][13] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Feeder */
	case 26: // STATE 1 - concurrente.pml:36 - [i = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->i;
		((P0 *)_this)->i = 0;
#ifdef VAR_RANGES
		logval("Feeder:i", ((P0 *)_this)->i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 2 - concurrente.pml:38 - [((i<4))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (!((((P0 *)_this)->i<4)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 28: // STATE 3 - concurrente.pml:38 - [jobs!i] (0:0:0 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		if (q_full(now.jobs))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.jobs);
		sprintf(simtmp, "%d", ((P0 *)_this)->i); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.jobs, 0, ((P0 *)_this)->i, 1);
		_m = 2; goto P999; /* 0 */
	case 29: // STATE 4 - concurrente.pml:38 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->i;
		((P0 *)_this)->i = (((P0 *)_this)->i+1);
#ifdef VAR_RANGES
		logval("Feeder:i", ((P0 *)_this)->i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 30: // STATE 5 - concurrente.pml:39 - [((i==4))] (16:0:2 - 1)
		IfNotBlocked
		reached[0][5] = 1;
		if (!((((P0 *)_this)->i==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: i */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->i;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->i = 0;
		/* merge: goto :b0(16, 6, 16) */
		reached[0][6] = 1;
		;
		/* merge: k = 0(16, 10, 16) */
		reached[0][10] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->k;
		((P0 *)_this)->k = 0;
#ifdef VAR_RANGES
		logval("Feeder:k", ((P0 *)_this)->k);
#endif
		;
		/* merge: .(goto)(0, 17, 16) */
		reached[0][17] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 31: // STATE 10 - concurrente.pml:42 - [k = 0] (0:16:1 - 3)
		IfNotBlocked
		reached[0][10] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->k;
		((P0 *)_this)->k = 0;
#ifdef VAR_RANGES
		logval("Feeder:k", ((P0 *)_this)->k);
#endif
		;
		/* merge: .(goto)(0, 17, 16) */
		reached[0][17] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 32: // STATE 11 - concurrente.pml:44 - [((k<2))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][11] = 1;
		if (!((((P0 *)_this)->k<2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 33: // STATE 12 - concurrente.pml:44 - [jobs!-(1)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][12] = 1;
		if (q_full(now.jobs))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.jobs);
		sprintf(simtmp, "%d",  -(1)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.jobs, 0,  -(1), 1);
		_m = 2; goto P999; /* 0 */
	case 34: // STATE 13 - concurrente.pml:44 - [k = (k+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][13] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->k;
		((P0 *)_this)->k = (((P0 *)_this)->k+1);
#ifdef VAR_RANGES
		logval("Feeder:k", ((P0 *)_this)->k);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 35: // STATE 14 - concurrente.pml:45 - [((k==2))] (0:0:1 - 1)
		IfNotBlocked
		reached[0][14] = 1;
		if (!((((P0 *)_this)->k==2)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: k */  (trpt+1)->bup.oval = ((P0 *)_this)->k;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->k = 0;
		_m = 3; goto P999; /* 0 */
	case 36: // STATE 19 - concurrente.pml:47 - [-end-] (0:0:0 - 3)
		IfNotBlocked
		reached[0][19] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

