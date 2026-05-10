	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */

	case 3: // STATE 1
		;
		((P3 *)_this)->w = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 5: // STATE 3
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 6: // STATE 4
		;
		((P3 *)_this)->w = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 5
		;
	/* 0 */	((P3 *)_this)->w = trpt->bup.oval;
		;
		;
		goto R999;

	case 8: // STATE 10
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Consumer */

	case 9: // STATE 1
		;
		((P2 *)_this)->processed = trpt->bup.oval;
		;
		goto R999;

	case 10: // STATE 2
		;
		XX = 1;
		unrecv(now.results, XX-1, 0, ((P2 *)_this)->idx, 1);
		((P2 *)_this)->idx = trpt->bup.oval;
		;
		;
		goto R999;

	case 11: // STATE 4
		;
		now.mtx = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 7
		;
		now.written[ Index(((P2 *)_this)->idx, 4) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 14: // STATE 9
		;
		now.next = trpt->bup.oval;
		;
		goto R999;

	case 15: // STATE 10
		;
		((P2 *)_this)->processed = trpt->bup.oval;
		;
		goto R999;

	case 16: // STATE 16
		;
		now.mtx = trpt->bup.oval;
		;
		goto R999;
;
		
	case 17: // STATE 18
		goto R999;
;
		
	case 18: // STATE 24
		goto R999;
;
		;
		
	case 20: // STATE 26
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Worker */

	case 21: // STATE 1
		;
		XX = 1;
		unrecv(now.jobs, XX-1, 0, ((P1 *)_this)->idx, 1);
		((P1 *)_this)->idx = trpt->bup.oval;
		;
		;
		goto R999;

	case 22: // STATE 2
		;
	/* 0 */	((P1 *)_this)->idx = trpt->bup.oval;
		;
		;
		goto R999;

	case 23: // STATE 5
		;
		_m = unsend(now.results);
		;
		goto R999;

	case 24: // STATE 11
		;
		now.done_workers = trpt->bup.oval;
		;
		goto R999;

	case 25: // STATE 13
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Feeder */

	case 26: // STATE 1
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 28: // STATE 3
		;
		_m = unsend(now.jobs);
		;
		goto R999;

	case 29: // STATE 4
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 30: // STATE 10
		;
		((P0 *)_this)->k = trpt->bup.ovals[1];
	/* 0 */	((P0 *)_this)->i = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 31: // STATE 10
		;
		((P0 *)_this)->k = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 33: // STATE 12
		;
		_m = unsend(now.jobs);
		;
		goto R999;

	case 34: // STATE 13
		;
		((P0 *)_this)->k = trpt->bup.oval;
		;
		goto R999;

	case 35: // STATE 14
		;
	/* 0 */	((P0 *)_this)->k = trpt->bup.oval;
		;
		;
		goto R999;

	case 36: // STATE 19
		;
		p_restor(II);
		;
		;
		goto R999;
	}

