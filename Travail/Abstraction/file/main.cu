#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#include "Matrice.h"
#include "Timer.h"

inline void usage(){printf("Calcul du produit de 2 matrice aléatoire :\n-t x : la dimension des matrices devient x*x\n-G : calcul sur le GPU au lieu du CPU\n-s x : la graine d'aléatoire devient x\n");exit(-1);}

inline int max2Int(const int a,const int b){if(a<b) return b; return a;}

inline void arguments(const int argc,char** argv,unsigned long *tailleMatrice,typeMemoire *memoryUsed,unsigned int *seed){
	int c;
	while((c=getopt(argc,argv,"Gt:s:"))!=-1){
		switch(c){
			case 'G':
				*memoryUsed=GPU;
				break;
			case 't':
				*tailleMatrice=max2Int(1,strtol(optarg,NULL,10));
				break;
			case 's':
				*seed=max2Int(0,strtol(optarg,NULL,10));
				break;
			default:
				usage();
				break;
		}
	}
}

int main(int argc, char** argv){	
	Timer *timerInitialisationMatrice=initialiserTimer(),*timerCalculMatrice=initialiserTimer();
	unsigned int seed = time(NULL);
	
	FILE *sortie = NULL;
	sortie = fopen("Resultat.txt","w");
	if(sortie==NULL){exit(505);}
	
	unsigned long tailleMatrice = 5;
	typeMemoire memoryUsed = CPU;
	arguments(argc,argv,&tailleMatrice,&memoryUsed,&seed);
	srand(seed);
	
	startTimer(timerInitialisationMatrice);
	
	Matrice *m = initialiserMatrice(tailleMatrice),*n=initialiserMatrice(tailleMatrice),*resultat=initialiserMatrice(tailleMatrice);
	initialiserSubMatrice(m,memoryUsed); remplirMatrice(m);
	initialiserSubMatrice(n,memoryUsed); remplirMatrice(n);
	initialiserSubMatrice(resultat,memoryUsed);
	
	stopTimer(timerInitialisationMatrice);
	
	startTimer(timerCalculMatrice);
	
	
	multiplicationMatrice(m,n,resultat);//CALCUL
	
	
	stopTimer(timerCalculMatrice);
	
	fprintf(sortie,"%f,%f",getTimerValue(timerInitialisationMatrice),getTimerValue(timerCalculMatrice));
	
	freeMatrice(m);
	freeMatrice(n);
	freeMatrice(resultat);
	freeTimer(timerInitialisationMatrice);
	freeTimer(timerCalculMatrice);
	fclose(sortie);
	return 0;
}
