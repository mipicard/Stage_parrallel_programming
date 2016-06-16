#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#include "Matrice.h"

inline void usage(){printf("Calcul du produit de 2 matrice aléatoire :\n-t x : la dimension des matrices devient x*x\n-G : calcul sur le GPU au lieu du CPU\n");exit(-1);}

inline int max2Int(const int a,const int b){if(a<b) return b; return a;}

inline void arguments(const int argc,char** argv,unsigned long *tailleMatrice,typeMemoire *memoryUsed){
	int c;
	while((c=getopt(argc,argv,"Gt:"))!=-1){
		switch(c){
			case 'G':
				*memoryUsed=GPU;
				break;
			case 't':
				*tailleMatrice=max2Int(1,strtol(optarg,NULL,10));
				break;
			default:
				usage();
				break;
		}
	}
}

int main(int argc, char** argv){	
	int t=sizeof(struct timeval);
	struct timeval *time1 = (struct timeval *) malloc(t), *time2 = (struct timeval *) malloc(t);
	if(time1==NULL || time2 == NULL){exit(9000);}
	srand(time(NULL));
	
	FILE *sortie = NULL;
	sortie = fopen("Resultat.txt","w");
	if(sortie==NULL){exit(505);}
	
	unsigned long tailleMatrice = 5;
	typeMemoire memoryUsed = CPU;
	arguments(argc,argv,&tailleMatrice,&memoryUsed);
	Matrice *m = initialiserMatrice(tailleMatrice),*n=initialiserMatrice(tailleMatrice),*resultat=initialiserMatrice(tailleMatrice);
	remplirMatrice(m,memoryUsed);
	remplirMatrice(n,memoryUsed);
	remplirMatrice(resultat,memoryUsed);
	
	if (gettimeofday(time1,NULL)){exit(1337);}
	
	multiplicationMatrice(m,n,resultat);//CALCUL
	
	if (gettimeofday(time2,NULL)){exit(1337);}
	fprintf(sortie,"%f\n",(time2->tv_sec - time1->tv_sec) + (float)(time2->tv_usec - time1->tv_usec)/1000000);
	
	freeMatrice(m);
	freeMatrice(n);
	freeMatrice(resultat);
	free(time1);
	free(time2);
	fclose(sortie);
	return 0;
}
