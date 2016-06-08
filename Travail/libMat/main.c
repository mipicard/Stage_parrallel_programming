/*
	MULTIPLICATION DE 2 MATRICE : M*N -> P
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <unistd.h>
#include <time.h>

#include "libMat.h"

int main(int argc, char* argv[]){
	srand48(time(NULL));
	// dim des matrices CARREE : Width * Width
	int Width = 5, r = 1;
	//utilises les arguments de la ligne de commandes.
	defArg(argc,argv,&Width,&r);
	
	// Allouer et initialiser les matrice M,N et P
	float *M=iniSquare(Width),*N=iniSquare(Width),*P1=iniSquare(Width);
	// Assigner les valeurs à M et N
	ask(M,N,Width,r);
	
	// Calcul de M*N -> P
	multCPU1_Square(M,N,P1,Width);
	
	// Afficher la matrice obtenu
	printf("\nP1 :");
	afficheMatriceSquare(P1,Width);
	//Libérer les matrices
	free(M);
	free(N);
	free(P1);
	return 0;
}
