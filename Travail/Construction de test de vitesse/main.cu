/*
	MULTIPLICATION DE 2 MATRICE : M*N -> P
*/

//Librairies non GPU
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <unistd.h>
#include <time.h>
#include <sys/time.h>

//Mes Librairies
#include "libMat.h"
#include "libMatGPU.h"

int main(int argc, char* argv[]){
	//Initialisation du drand48, des variables de bases, des 2 matrice à multiplier entre elle et des 2 matrices résultats
	
	int t=sizeof(struct timeval);
	struct timeval *time1 = NULL, *time2 =NULL;
	srand(time(NULL));
	int Width = 5, r = 1, a=0, gpu = 0, rotate = 1,i;
	defArg(argc,argv,&Width,&r,&a,&gpu,&rotate);
	float *M=NULL,*N=NULL,*P=NULL;
	
	FILE *sortie = NULL;
	sortie = fopen("Resultat.txt","a");
	if(sortie==NULL){exit(EXIT_FAILURE);}
	
	for(i=0;i<rotate;i++){
		M=iniSquare(Width);N=iniSquare(Width);P=iniSquare(Width);
		time1 = (struct timeval *) malloc(t);time2 = (struct timeval *) malloc(t);
		ask(M,N,Width,r,a);
		
		if (gettimeofday(time1,NULL)){exit(EXIT_FAILURE);}
		switch(gpu){
			case 1:
				multGPU1_Square(M,N,P,Width);
				break;
			case 2:
				multGPU2_Square(M,N,P,Width);
				break;
			case 3:
				multGPU3_Square(M,N,P,Width);
				break;
			default:
				multCPU1_Square(M,N,P,Width);
				break;
		}
		if (gettimeofday(time2,NULL)){exit(EXIT_FAILURE);}
		
		if (a!=0){
			printf("\nP : ");
			afficheMatriceSquare(P,Width);
		}
		
		fprintf(sortie,"%f\n",(time2->tv_sec - time1->tv_sec) + (float)(time2->tv_usec - time1->tv_usec)/1000000);
		
		free(M);
		free(N);
		free(P);
		free(time1);
		free(time2);
	}
	fclose(sortie);
	
	return 0;
}
