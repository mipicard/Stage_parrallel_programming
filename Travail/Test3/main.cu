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
	srand(time(NULL));
	int Width = 5, r = 1, a=0;
	defArg(argc,argv,&Width,&r,&a);
	float *M=iniSquare(Width),*N=iniSquare(Width),*P1=iniSquare(Width),*P2=iniSquare(Width);
	ask(M,N,Width,r,a);
	
	// Calcul de M*N -> P
	multGPU2_Square(M,N,P1,Width);
	multGPU3_Square(M,N,P2,Width);
	if (a!=0){
		printf("\nP1 : ");
		afficheMatriceSquare(P1,Width);
		printf("\nP2 : ");
		afficheMatriceSquare(P2,Width);
	}
	
	// vérification de l'égalité des matrices
	if(equalSquareMatrix(P1,P2,Width))
	{
		printf("\nAlgorithme bon, passez aux tests du temps d'execution\n");
	}
	else
	{
		printf("\nRevoyez l'algorithme.\n");
	}
	//Libérer les matrices
	free(M);
	free(N);
	free(P1);
	return 0;
}
