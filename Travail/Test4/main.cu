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
		//time_t time1 = time(NULL);
	int t=sizeof(struct timeval);
	struct timeval *time1 =(struct timeval *) malloc(t), *time2 =(struct timeval *) malloc(t);
	if (gettimeofday(time1,NULL)){exit(EXIT_FAILURE);}
	srand(time(NULL));
	int Width = 5, r = 1, a=0;
	defArg(argc,argv,&Width,&r,&a);
	float *M=iniSquare(Width),*N=iniSquare(Width),*P1=iniSquare(Width),*P2=iniSquare(Width);
	ask(M,N,Width,r,a);
	
	// Calcul de M*N -> P
	multGPU2_Square(M,N,P1,Width);
	if (a!=0){
		printf("\nP1 : ");
		afficheMatriceSquare(P1,Width);
		printf("\nP2 : ");
		afficheMatriceSquare(P2,Width);
	}
	//Libérer les matrices
	free(M);
	free(N);
	free(P1);
	if (gettimeofday(time2,NULL)){exit(EXIT_FAILURE);}
	printf("\nTemps ecoule : %f s\n",(time2->tv_sec - time1->tv_sec) + (float)(time2->tv_usec - time1->tv_usec)/1000000);
		//time_t time2 = time(NULL);
		//printf("\nTemps ecoule : %f\n",difftime(time2,time1));
	return 0;
}
