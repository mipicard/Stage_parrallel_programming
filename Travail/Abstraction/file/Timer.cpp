#include <sys/time.h>
#include <stdlib.h>
#include "Timer.h"

inline static void pointeurNonAlloueTimer(Timer *t){if(t==NULL){exit(9000);}}
inline static void pointeurNonAlloue(struct timeval *t){if(t==NULL){exit(9000);}}

inline static float differenceTimer(const struct timeval *tOrigin,const struct timeval *tEnd){
	return (tEnd->tv_sec - tOrigin->tv_sec) + (float)(tEnd->tv_usec - tOrigin->tv_usec)/1000000;
}

inline static void giveValTimer(struct timeval *t){
	if (gettimeofday(t,NULL)){exit(1337);}
}



Timer *initialiserTimer(){
	Timer *t=(Timer *)malloc(sizeof(Timer));
	pointeurNonAlloueTimer(t);
	t->start = (struct timeval *)malloc(sizeof(struct timeval));
	pointeurNonAlloue(t->start);
	t->stop=(struct timeval *)malloc(sizeof(struct timeval));
	pointeurNonAlloue(t->stop);
	t->valeur=0.0;
	t->etat=STOP;
	return t;
}

void freeTimer(Timer *t){
	if(t!=NULL){
		free(t->start);
		free(t->stop);
		free(t);
		t=NULL;
	}
}

void startTimer(Timer *t){
	if(t->etat!=START){
		giveValTimer(t->start);
		t->valeur=0.0;
		t->etat=START;
	}
}

void stopTimer(Timer *t){
	if(t->etat!=STOP){
		giveValTimer(t->stop);
		t->etat=STOP;
		t->valeur=differenceTimer(t->start,t->stop);
	}
}

float getTimerValue(Timer *t){return t->valeur;}
