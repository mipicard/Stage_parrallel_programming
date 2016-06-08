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

//Mes Librairies
#include "libMat.h"
#include "libMatGPU.h"

int main(int argc, char* argv[]){
	//Initialisation du drand48, des variables de bases, des 2 matrice à multiplier entre elle et des 2 matrices résultats
	srand48(time(NULL));
	int Width = 5, r = 1, a=1;
	defArg(argc,argv,&Width,&r,&a);
	float *M=iniSquare(Width),*N=iniSquare(Width),*P1=iniSquare(Width),*P2=iniSquare(Width);
	ask(M,N,Width,r,a);
	
	// Calcul de M*N -> P
	multCPU1_Square(M,N,P1,Width);
	multGPU1_Square(M,N,P2,Width);
	
	printf("\nP1 : ");
	afficheMatriceSquare(P1,Width);
	printf("\nP2 : ");
	afficheMatriceSquare(P2,Width);
	
	// vérification de l'égalité des matrices
	if(equalSquareMatrix(P1,P2,Width))
	{
		printf("\nAlgorithme bon, passez aux tests du temps d'execution\n");
	}
	else
	{
		printf("\nRevoyez l'algorithme, ou les calculs sont trop imprécis ,faites le test avec des entiers?\n");
	}
	//Libérer les matrices
	free(M);
	free(N);
	free(P1);
	return 0;
}
