#include <stdlib.h>
#include <string.h>
#include "DEBUG.h"

#include "Element.h"
#include "MatriceGPU.h"

__host__ __device__ inline static unsigned int positionElement(const unsigned int i,const unsigned int j,const MatriceGPU *m){return i*m->dimension+j;}

inline static void pointeurNonAlloue(const void *pointeur){if(!(pointeur == NULL)){exit(84);}}

inline static void cudaFail(cudaError_t e){if(e != cudaSuccess){exit(85);}}

inline void matriceNonInitialiseGPU(const MatriceGPU *pointeur){pointeurNonAlloue(pointeur);pointeurNonAlloue(pointeur->matrice);}

static int divMaxDim(const int dim){
	int answer = 32;
	while(dim%answer){answer--;}
	return answer;
}

MatriceGPU *initialiserMatriceGPU(const unsigned long taille){
	const unsigned long qtMemory = taille*taille*sizeof(Element);
	MatriceGPU *m = NULL;
	cudaFail(cudaMalloc((void **)&m,sizeof(MatriceGPU)));
	m->matrice = NULL;
	cudaFail(cudaMalloc((void **)&(m->matrice),qtMemory));
	cudaFail(cudaMemset(m->matrice,ZERO_ELEMENT,qtMemory));
	return m;
}

void freeMatriceGPU(MatriceGPU *m){
	if(m!=NULL){
		cudaFree(m->matrice);
		cudaFree(m);
		m=NULL;
	}
}

__global__ static void additionMatriceGPU_Kernel(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat,const int nbThreadPerBlock){
	unsigned long ligne = blockIdx.y*nbThreadPerBlock+threadIdx.y,colonne = blockIdx.x*nbThreadPerBlock +threadIdx.x;
	resultat->matrice[positionElement(ligne,colonne,resultat)]=additionElement(m1->matrice[positionElement(ligne,colonne,m1)],m2->matrice[positionElement(ligne,colonne,m2)]);
}

void additionMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat){
	const unsigned long dim=resultat->dimension;
	int div = divMaxDim(dim);
	int divG = dim/div;
	dim3 dimBlock(div,div,1),dimGrid(divG,divG,1);
	
	additionMatriceGPU_Kernel<<<dimGrid,dimBlock>>>(m1,m2,resultat,div);
	
}

__global__ static void multiplicationMatriceGPU_Kernel(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat,const int nbThreadPerBlock){
	unsigned long ligne= blockIdx.y*nbThreadPerBlock + threadIdx.y, colonne= blockIdx.x*nbThreadPerBlock + threadIdx.x;
	Element sum = ZERO_ELEMENT;
	
	for(int k=0;k<resultat->dimension;k++){
		sum = additionElement(sum,multiplicationElement(m1->matrice[ligne*m1->dimension+k],m2->matrice[k*m2->dimension+colonne]));;
	}
	
	resultat->matrice[positionElement(ligne,colonne,resultat)] = sum;
}

void multiplicationMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat){
	const unsigned long dim=resultat->dimension;
	int div = divMaxDim(dim);
	int divG = dim/div;
	dim3 dimBlock(div,div,1),dimGrid(divG,divG,1);
	
	multiplicationMatriceGPU_Kernel<<<dimGrid,dimBlock>>>(m1,m2,resultat,div);
}

int matriceEqualGPU(const MatriceGPU *m1,const MatriceGPU *m2){
	int res=1,i=0,j;
	while(res && i<m1->dimension){
		j=0;
		while(res && j<m1->dimension){
			res = equalElement(m1->matrice[positionElement(i,j,m1)],m2->matrice[positionElement(i,j,m2)]);
			j++;
		}
		i++;
	}
	return res;
}

void fillRandomMatriceGPU(MatriceGPU *m){
	for(int i=0;i<m->dimension;i++){
		for(int j=0;j<m->dimension;j++)
			m->matrice[positionElement(i,j,m)] = randomElement();		
	}
}
