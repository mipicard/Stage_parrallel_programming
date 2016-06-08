/*
	MULTIPLICATION DE 2 MATRICE : M*N -> P
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

float* iniSquare(const int dim);
void multCPU1_Square(const float *M,const float *N,float *P,const int Width);
void afficheMatriceSquare(const float *mat, const int Width);

int main(int argc, char* argv[]){
	
	// dim des matrices CARREE : Width * Width
	int Width = 10;
	
	// Allouer et initialiser les matrice M,N et P
	float *M=iniSquare(Width),*N=iniSquare(Width),*P=iniSquare(Width);
	// Assigner les valeurs à M et N
	
	
	// Calcul de M*N -> P
	multCPU1_Square(M,N,P,Width);
	
	// Afficher la matrice obtenu
	afficheMatriceSquare(P,Width);
	//Libérer les matrices
	free(M);
	free(N);
	free(P);
	return 0;
}

float* iniSquare(const int dim){
	float *mat = malloc(dim*dim*sizeof(float));
	if(mat == NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<dim*dim;i++){
		mat[i]=0;
	}
	return mat;
}

void multCPU1_Square(const float *M,const float *N,float *P,const int Width){
	int i,j,k;
	float sum,tmpM,tmpN;
	for(i=0;i<Width;i++)
	{
		for(j=0;i<Width;i++){
			sum = 0;
			for(k=0;k<Width;k++){
				tmpM = M[i*Width+k];
				tmpN = N[k*Width+j];
				sum += tmpM * tmpN;
			}
			P[i*Width+j] = sum;
		}
	}
}

void afficheMatriceSquare(const float *mat, const int Width){
	int i,j;
	for(i=0;i<Width;i++){
		printf("\n[ ");
		for(j=0;j<Width;j++){
			printf("%f ",mat[i*Width+j]);
		}
		printf("]");
	}
	printf("\n");
}
