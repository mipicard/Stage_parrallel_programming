/*
	MULTIPLICATION DE 2 MATRICE : M*N -> P
	Sur GPU
*/
// Librairies non GPU
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "libMat.h" //Librairie des matrices sur CPU
#include "libMatGPU.h"

void multGPU1_Square(const float *M,const float *N,float *P,const int Width){
	if(Width>512){printf("L'algorithme actuel ne permet pas des calculs de matrices de taille supérieur à 512");exit(EXIT_SUCCESS);}
	int taille = Width * Width * sizeof(float);
	
	//initialisation des matrices sur le GPU
	float *Mg=iniSquareGPU(M,taille),*Ng=iniSquareGPU(N,taille);
	float *Pg=NULL;
	if((cudaMalloc((void **)&Pg,taille))!=cudaSuccess){exit(EXIT_FAILURE);}
	
	//appel la fonction de calcul
	dim3 dimBlock(Width,Width,1), dimGrid(1,1,1); // définition de la structure 3D des blocs et de la grille
	/*
		block : structure des threads par blocs, ici en une matrice carrée, donc Width x Width x 1
		grille : ici, on n'utilise que 1 bloc de calcul, donc 1 x 1 x 1
	*/
	multGPU1_Square_aux<<<dimBlock,dimGrid>>>(Mg,Ng,Pg,Width);
	//copie de la matrice obtenue
	if((cudaMemcpy(P,Pg,taille,cudaMemcpyDeviceToHost)) != cudaSuccess){exit(EXIT_FAILURE);}
	//libération des matrices sur le GPU
	cudaFree(Mg);
	cudaFree(Ng);
	cudaFree(Pg);
}

float* iniSquareGPU(const float *M,const int taille){
	float *Mg=NULL;
	if((cudaMalloc((void **)&Mg,taille)) != cudaSuccess){exit(EXIT_FAILURE);}
	if((cudaMemcpy(Mg,M,taille,cudaMemcpyHostToDevice)) != cudaSuccess){exit(EXIT_FAILURE);}
	return Mg;
}

__global__ void multGPU1_Square_aux(const float *Mg,const float *Ng,float *Pg,const int Width){
	// ID des threads (ici en 2d puisque que l'on est en matrice 2d)
	int tx = threadIdx.x,ty = threadIdx.y,k;
	
	//variable somme
	float sum = 0,eMg,eNg;
	
	//calcul de chaque case de P, référencé par tx et ty
	for(k=0;k<Width;k++){
		eMg = Mg[ty*Width+k];
		eNg = Ng[k*Width+tx];
		sum+= eMg * eNg;
	}
	// inscris la valeur dans la case correspondante
	Pg[ty*Width+tx] = sum;
}
