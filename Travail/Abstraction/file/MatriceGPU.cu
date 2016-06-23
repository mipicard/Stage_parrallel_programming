#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "DEBUG.h"

#include "Element.h"
#include "MatriceGPU.h"


//__device__ float equal;

__host__ __device__ inline static unsigned int positionElement(const unsigned int i,const unsigned int j,const MatriceGPU *m){return i*m->dimension+j;}

inline static void pointeurNonAlloue(const void *pointeur){if(pointeur == NULL){exit(84);}}

inline static void cudaFail(cudaError_t e){if(e != cudaSuccess){exit(85);}}

inline void matriceNonInitialiseGPU(const MatriceGPU *pointeur){pointeurNonAlloue(pointeur);pointeurNonAlloue(pointeur->matrice);}

static int divMaxDim(const int dim){
	int answer = 32;
	while(dim%answer){answer--;}
	return answer;
}

MatriceGPU *initialiserMatriceGPU(const unsigned long taille){
	const unsigned long qtMemory = taille*taille*sizeof(Element);
	MatriceGPU *m = (MatriceGPU *)malloc(sizeof(MatriceGPU));
	pointeurNonAlloue(m);
	cudaFail(cudaMalloc((void **)&m->matrice,qtMemory));
	m->dimension=taille;
	return m;
}

void freeMatriceGPU(MatriceGPU *m){
	if(m!=NULL){
		cudaFree(m->matrice);
		free(m);
		m=NULL;
	}
}

__global__ static void additionMatriceGPU_Kernel(const MatriceGPU m1,const MatriceGPU m2,MatriceGPU resultat,const int nbThreadPerBlock){
	unsigned long ligne = blockIdx.y*nbThreadPerBlock+threadIdx.y,colonne = blockIdx.x*nbThreadPerBlock +threadIdx.x;
	resultat.matrice[positionElement(ligne,colonne,&resultat)]=additionElement(m1.matrice[positionElement(ligne,colonne,&m1)],m2.matrice[positionElement(ligne,colonne,&m2)]);
}

void additionMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat){
	const unsigned long dim=resultat->dimension;
	int div = divMaxDim(dim);
	int divG = dim/div;
	dim3 dimBlock(div,div,1),dimGrid(divG,divG,1);
	
	additionMatriceGPU_Kernel<<<dimGrid,dimBlock>>>(*m1,*m2,*resultat,div);
	
}

#ifdef GPU_OPTI
__global__ static void multiplicationMatriceGPU_Kernel(const MatriceGPU m1,const MatriceGPU m2,MatriceGPU resultat,const int nbThreadPerBlock){
	Element sum = ZERO_ELEMENT;
	__shared__ Element Mgshader[32][32]; //On met le nbThreadPerBlock maximal possible, sinon il est impossible d'utiliser cette méthode...
	__shared__ Element Ngshader[32][32];
	
	int bx=blockIdx.x,by=blockIdx.x,tx=threadIdx.x,ty=threadIdx.y;
	int ligne = by*nbThreadPerBlock+ty, colonne = bx*nbThreadPerBlock+tx;
	unsigned long Width = resultat.dimension;
	
	for(int s=0;s<(Width/nbThreadPerBlock);s++)
	{
		Mgshader[ty][tx]=m1.matrice[ligne*Width+(s*nbThreadPerBlock + tx)];
		Ngshader[ty][tx]=m2.matrice[colonne+Width*(s*nbThreadPerBlock + ty)];
		__syncthreads();
		
		for(int k=0;k<nbThreadPerBlock;k++){
			sum=additionElement(sum,multiplicationElement(Mgshader[ty][k],Ngshader[k][tx]));
		}
		__syncthreads();
	}
	resultat.matrice[ligne*Width+colonne] = sum;
}
#elif GPU_OPTI_M
__global__ static void multiplicationMatriceGPU_Kernel(const MatriceGPU m1,const MatriceGPU m2,MatriceGPU resultat){
	Element sum[4];
	for(int i=0;i<4;i++)
		sum[i]=ZERO_ELEMENT;
	
	__shared__ Element Mgshader[64][64];
	__shared__ Element Ngshader[64][64];
	
	int bx=blockIdx.x,by=blockIdx.x,tx=threadIdx.x,ty=threadIdx.y;
	for(int s=0;s<gridDim.x;s++){
		for(int i=0;i<4;i++){
			Mgshader[ty+i*64][tx]=m1.matrice[];
			Mgshader[ty+i*64][tx]=m2.matrice[];
		}
		__syncthreads();
		for(int i=0;i<4;i++){
			for(int k=0;k<64;k++)
				sum[i]=additionElement(sum[i],multiplicationElement(Mgshader[ty+i*64][k],Ngshader[k][tx+i*16]));
		}
		__syncthreads();
	}
	for(int i=0;i<4;i++)
		
	__syncthreads();
}
#else
__global__ static void multiplicationMatriceGPU_Kernel(const MatriceGPU m1,const MatriceGPU m2,MatriceGPU resultat,const int nbThreadPerBlock){
	unsigned long ligne= blockIdx.y*nbThreadPerBlock + threadIdx.y, colonne= blockIdx.x*nbThreadPerBlock + threadIdx.x;
	Element sum = ZERO_ELEMENT;
	
	for(int k=0;k<resultat.dimension;k++){
		sum = additionElement(sum,multiplicationElement(m1.matrice[ligne*m1.dimension+k],m2.matrice[k*m2.dimension+colonne]));;
	}
	
	resultat.matrice[positionElement(ligne,colonne,&resultat)] = sum;
}
#endif

#ifdef GPU_OPTI_M
inline static unsigned long dimSUP(const unsigned long dim){
	unsigned long tmp = dim&((1<<6)-1);
	return (tmp==0)?dim:(dim+(1<<6)-tmp);
}
static void cpMatriceDimDiff(const MatriceGPU *origin,MatriceGPU *backend){
	unsigned long m=(origin->dimension > backend->dimension)?backend->dimension:origin->dimension;
	for(int i=0;i<m;i++){
		for(int j=0;j<m;j++)
			cudaMemcpy(&(backend->matrice[i*backend->dimension+j]),&(origin->matrice[i*origin->dimension+j]),sizeof(Element),cudaMemcpyDeviceToDevice);
	}
}
/*
static unsigned long dimSUP(const unsigned long dim){
	unsigned long dimSup = 64;
	while(dim>=dimSup)
		dimSup=dimSup<<1;
	return dimSup;
}
*/
void multiplicationMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat){
	const unsigned long dim=resultat->dimension;
	unsigned long dimSup=dimSUP(dim);
	unsigned long nbBlock=dimSup>>6;
	printf("%lu : %lu \n",dim,dimSup);
	dim3 dimBlock(64,16,1),dimGrid(nbBlock,nbBlock,1);
		MatriceGPU *m1bis=initialiserMatriceGPU(dimSup);MatriceGPU *m2bis=initialiserMatriceGPU(dimSup);
		cpMatriceDimDiff(m1,m1bis);cpMatriceDimDiff(m2,m2bis);
		MatriceGPU *resultatbis=initialiserMatriceGPU(dimSup);
	multiplicationMatriceGPU_Kernel<<<dimGrid,dimBlock>>>(*m1bis,*m2bis,*resultatbis);
		cpMatriceDimDiff(resultatbis,resultat);
		freeMatriceGPU(m1bis);freeMatriceGPU(m2bis);freeMatriceGPU(resultatbis);
	cudaDeviceSynchronize();
}
#else
void multiplicationMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat){
	const unsigned long dim=resultat->dimension;
	int div = divMaxDim(dim);
	int divG = dim/div;
	dim3 dimBlock(div,div,1),dimGrid(divG,divG,1);
	
	multiplicationMatriceGPU_Kernel<<<dimGrid,dimBlock>>>(*m1,*m2,*resultat,div);
	cudaDeviceSynchronize();
}
#endif
/*
__global__ static void matriceEqualGPU_Kernel(const MatriceGPU m1,const MatriceGPU m2,const int nbThreadPerBlock){
	__shared__ float answer;
	answer = 0.0;
	unsigned long ligne= blockIdx.y*nbThreadPerBlock + threadIdx.y, colonne= blockIdx.x*nbThreadPerBlock + threadIdx.x;
	answer += (!(equalElement(m1.matrice[positionElement(ligne,colonne,&m1)],m2.matrice[positionElement(ligne,colonne,&m2)])));
	__syncthreads();
	equal+=answer;
	
}

int matriceEqualGPU(const MatriceGPU *m1,const MatriceGPU *m2){
	equal = 0.0;
	const unsigned long dim=m1->dimension;
	int div = divMaxDim(dim);
	int divG = dim/div;
	dim3 dimBlock(div,div,1),dimGrid(divG,divG,1);
	
	matriceEqualGPU_Kernel<<<dimGrid,dimBlock>>>(*m1,*m2,div);
	return (equal==0.0);
}
*/
void fillRandomMatriceGPU(MatriceGPU *m){
	unsigned long qtMemory = m->dimension*m->dimension*sizeof(Element);
	Element *sub = (Element *) malloc(qtMemory);
	pointeurNonAlloue(sub);
	for(int i=0;i<m->dimension;i++){
		for(int j=0;j<m->dimension;j++)
			sub[positionElement(i,j,m)]=randomElement();		
	}
	cudaMemcpy(m->matrice,sub,qtMemory,cudaMemcpyHostToDevice);
}
