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

#define NOT_ASK_MAT 0

float* iniSquare(const int dim);
void multCPU1_Square(const float *M,const float *N,float *P,const int Width);
void afficheMatriceSquare(const float *mat, const int Width);
void askValueMatriceSquare(float* mat,const int Width);

//typedef void (*)(const float,const float, float, const int) fct_matmult;

//fct_matmult f;

int main(int argc, char* argv[]){
	srand(time(NULL));
	// dim des matrices CARREE : Width * Width
	int Width = 2;
	
	//lire les arguments
	//f=multCPU1_Square
	
	// Allouer et initialiser les matrice M,N et P
	float *M=iniSquare(Width),*N=iniSquare(Width),*P1=iniSquare(Width);
	// Assigner les valeurs à M et N
	askValueMatriceSquare(M,Width);
	printf("M :");
	afficheMatriceSquare(M,Width);
	askValueMatriceSquare(N,Width);
	printf("\nN :");
	afficheMatriceSquare(N,Width);
	
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
		for(j=0;j<Width;j++){
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

void askValueMatriceSquare(float* mat,const int Width){
	int i,j;
	if(NOT_ASK_MAT){
		for(i=0;i<Width;i++){
			for(j=0;j<Width;j++){
				mat[i*Width+j]=(rand()-(RAND_MAX/2))/(double)(100000000);
			}
		}
	}
	else
	{
		float f;
		for(i=0;i<Width;i++){
			for(j=0;j<Width;j++){
				f=0;
				printf("VAR %d.%d : ",i,j);
				//scanf("%f",(mat+(i*Width+j)*sizeof(float)));
				// scanf("%f",mat[i*Width+j]);
				scanf("%f",&f);
				mat[i*Width+j]=f;
			}
		}
	}
}
