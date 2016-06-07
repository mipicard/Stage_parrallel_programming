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

float* iniSquare(const int dim){
	float *mat = (float *)malloc(dim*dim*sizeof(float));
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

void askValueMatriceSquare(float* mat,const int Width, const int r){
	int i,j;
	float f;
	switch(r){
	case 1:
		for(i=0;i<Width;i++){
			for(j=0;j<Width;j++){
				mat[i*Width+j]=drand48();
			}
		}
		break;
	case 0:
		printf("\n");
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
		break;
	default:
		exit(EXIT_FAILURE);
		break;
	}
}

void ask(float *M,float *N,const int Width,const int r){
	printf("M :");
	askValueMatriceSquare(M,Width,r);
	if(r!=0){afficheMatriceSquare(M,Width);}
	printf("\nN :");
	askValueMatriceSquare(N,Width,r);
	if(r!=0){afficheMatriceSquare(N,Width);}
}

void usage(){
	printf("Calculera le produit de 2 matrice aléatoire\n");
	printf(" -t : permet à l'utilisateur de définir la taille des matrices\n");
	printf(" -c : permet à l'utilisateur de remplir de lui même les matrices\n");
	exit(0);
}

void defArg(const int argc,char* argv[], int *w, int *r){
	int c;
	while((c = getopt (argc, argv, "?t:c:"))!=-1){
		switch(c){
			case 't':
				*w = max2Int(1,strtol(optarg,NULL,10));
				break;
			case 'c':
				*r = (int)strtol(optarg,NULL,10);
				break;
			case '?':
				usage();
				break;
			default:
				usage();
				break;
		}
	}
}

int max2Int(const int a,const int b){
	if(a<b){return b;}
	return a;
}

int equalSquareMatrix(const float *mat1,const float *mat2,const int Width){
	int answer = 1,i=0,j=0;
	while(answer && i<Width){
		j=0;
		while(answer && j<Width){
			answer = (mat1[i*Width+j]==mat2[i*Width+j]);
			j++;
		}
		i++;
	}
	return answer;
}
