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


float* iniSquareGPU(const float *M,const int taille){
	float *Mg=NULL;
	if((cudaMalloc((void **)&Mg,taille)) != cudaSuccess){exit(EXIT_FAILURE);}
	if((cudaMemcpy(Mg,M,taille,cudaMemcpyHostToDevice)) != cudaSuccess){exit(EXIT_FAILURE);}
	return Mg;
}


// 1ere version du multiplicateur de matrice, limité à des matrices 32*32 maximum
void multGPU1_Square(const float *M,const float *N,float *P,const int Width){
	if(Width*Width>1024){printf("\nL'algorithme actuel ne permet pas des calculs de matrices d'aires supérieur à 2^10\n");exit(EXIT_SUCCESS);}
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
	multGPU1_Square_aux<<<dimGrid,dimBlock>>>(Mg,Ng,Pg,Width); //La grille puis les blocs
	
	//copie de la matrice obtenue
	if((cudaMemcpy(P,Pg,taille,cudaMemcpyDeviceToHost)) != cudaSuccess){exit(EXIT_FAILURE);}
	//libération des matrices sur le GPU
	cudaFree(Mg);
	cudaFree(Ng);
	cudaFree(Pg);
}

__global__ void multGPU1_Square_aux(float *Mg,float *Ng,float *Pg,int Width){
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


//2eme version, avec des matrices allant jusqu'à des taille de 65535*65535 de blocs de 32*32
void multGPU2_Square(const float *M,const float *N,float *P,const int Width){
	int taille = Width * Width * sizeof(float);
	
	//initialisation des matrices sur le GPU
	float *Mg=iniSquareGPU(M,taille),*Ng=iniSquareGPU(N,taille);
	float *Pg=NULL;
	if((cudaMalloc((void **)&Pg,taille))!=cudaSuccess){exit(EXIT_FAILURE);}
	
	//appel la fonction de calcul
		//initialisation des dimensions des blocks et de la grille
		int div = divMaxDim(Width);
		int divG = Width/div;
		if(divG>65535){printf("Erreur : la séparation en block n'est pas assez efficace pour cette dimension");exit(0);}
		dim3 dimBlock(div,div,1),dimGrid(divG,divG,1);
		
		//appel du kernel
		multGPU2_Square_aux<<<dimGrid,dimBlock>>>(Mg,Ng,Pg,Width,div);
	
	//copie de la matrice obtenue
	if((cudaMemcpy(P,Pg,taille,cudaMemcpyDeviceToHost)) != cudaSuccess){exit(EXIT_FAILURE);}
	//libération des matrices sur le GPU
	cudaFree(Mg);
	cudaFree(Ng);
	cudaFree(Pg);
}

__global__ void multGPU2_Square_aux(float *Mg,float *Ng,float *Pg,int Width,int nbThreadPerBlock){
	int ligne= blockIdx.y*nbThreadPerBlock + threadIdx.y, colonne= blockIdx.x*nbThreadPerBlock + threadIdx.x,k;
	float sum = 0;
	
	for(k=0;k<Width;k++){
		sum+= Mg[ligne*Width+k] * Ng[k*Width+colonne];;
	}
	
	Pg[ligne*Width+colonne] = sum;
}

int divMaxDim(const int dim){
	int answer = 32;
	while(dim%answer){answer--;}
	return answer;
}

