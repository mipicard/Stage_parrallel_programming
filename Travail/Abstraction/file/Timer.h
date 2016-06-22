#ifndef TIMER_H_INCLUDED
#define TIMER_H_INCLUDED

typedef enum{START,STOP} EtatTimer;

typedef struct Timer Timer;
struct Timer{
	struct timeval *start;
	struct timeval *stop;
	float valeur;
	EtatTimer etat;
};

Timer *initialiserTimer();
void freeTimer(Timer *t);
void startTimer(Timer *t);
void stopTimer(Timer *t);
float getTimerValue(Timer *t);

#endif //TIMER_H_INCLUDED
