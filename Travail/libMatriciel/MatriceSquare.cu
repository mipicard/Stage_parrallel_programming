#include <stdio.h>
#include <stdlib.h>

#include "MatriceSquare.h"

// INITIALISATION DE MATRICE
Matrice* initialiserMatrice(const int taille,const typeMat type){
	Matrice *m=NULL;
	switch(type){
		case TYPE_INT:
			m=initialiserMatrice_INT(taille);
			break;
		case TYPE_FLOAT:
			m=initialiserMatrice_FLOAT(taille);
			break;
		default:
			printf("Vous n'avez pas spécifiez un type valide\n");
			exit(EXIT_FAILURE);
	}
	return m;
}

Matrice* initialiserMatrice_INT(const int taille){
	Matrice* m =(Matrice *) malloc(sizeof(Matrice));
	if(m==NULL){exit(EXIT_FAILURE);}
	m->matrice.matInt = (int *) malloc(taille*taille*sizeof(int));
	if(m->matrice.matInt==NULL){exit(EXIT_FAILURE);}
	m->type = TYPE_INT;
	m->dimension = taille;
	matriceRaZ_INT(m);
	return m;
}

Matrice* initialiserMatrice_FLOAT(const int taille){
	Matrice* m =(Matrice *) malloc(sizeof(Matrice));
	if(m==NULL){exit(EXIT_FAILURE);}
	m->matrice.matFloat = (float *) malloc(taille*taille*sizeof(float));
	if(m->matrice.matFloat==NULL){exit(EXIT_FAILURE);}
	m->type = TYPE_FLOAT;
	m->dimension = taille;
	matriceRaZ_FLOAT(m);
	return m;
}

// MISE A ZERO DE MATRICE
void matriceRaZ(Matrice *m){
	if(m==NULL){exit(EXIT_FAILURE);}
	switch(m->type){
		case TYPE_INT:
			matriceRaZ_INT(m);
			break;
		case TYPE_FLOAT:
			matriceRaZ_FLOAT(m);
		default:
			exit(EXIT_FAILURE);
	}
}

void matriceRaZ_INT(Matrice *m){
	if(m==NULL || m->matrice.matInt==NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<(m->dimension * m->dimension);i++)
		m->matrice.matInt[i]=0;
}

void matriceRaZ_FLOAT(Matrice *m){
	if(m==NULL || m->matrice.matFloat==NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<(m->dimension * m->dimension);i++)
		m->matrice.matFloat[i]=0.0;
}

// COPIE DE MATRICE
Matrice *cpMatrice(const Matrice *m){
	if(m==NULL){exit(EXIT_FAILURE);}
	Matrice *m2 = NULL;
	switch(m->type){
		case TYPE_INT:
			m2=cpMatrice_INT(m);
			break;
		case TYPE_FLOAT:
			m2=cpMatrice_FLOAT(m);
		default:
			exit(EXIT_FAILURE);
	}
	return m2;
}

Matrice *cpMatrice_INT(const Matrice *m){
	if(m==NULL || m->matrice.matInt==NULL){exit(EXIT_FAILURE);}
	Matrice *m2= initialiserMatrice(m->dimension,m->type);
	if(m2==NULL || m2->matrice.matInt == NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<(m2->dimension * m2->dimension);i++)
		m2->matrice.matInt[i] = (int) m->matrice.matInt[i];
	return m2;
}

Matrice *cpMatrice_FLOAT(const Matrice *m){
	if(m==NULL || m->matrice.matFloat==NULL){exit(EXIT_FAILURE);}
	Matrice *m2= initialiserMatrice(m->dimension,m->type);
	if(m2==NULL || m2->matrice.matFloat == NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<(m2->dimension * m2->dimension);i++)
		m2->matrice.matFloat[i] = (float) m->matrice.matFloat[i];
	return m2;
}

// LIBERATION DE MATRICE
void freeMatrice(Matrice *m){
	if(m!=NULL){
		free(m->matrice.matInt);
		free(m->matrice.matFloat);
		free(m);
		m=NULL;
	}
}

// CHANGEMENT DU TYPE DE LA MATRICE
void swapTypeMatrice(Matrice *m,const typeMat type){
	if(m==NULL || (m->matrice.matInt == NULL && m->matrice.matFloat == NULL)){exit(EXIT_FAILURE);}
	if(type != m->type){
		Matrice *m2 = initialiserMatrice(m->dimension,m->type);
		if(m2==NULL || (m2->matrice.matInt == NULL && m2->matrice.matFloat == NULL)){exit(EXIT_FAILURE);}
		int i;
		switch(type){
			case TYPE_INT:
				for(i=0;i<(m2->dimension * m2->dimension);i++)
					m2->matrice.matInt[i] = (int) m->matrice.matFloat[i];
				break;
			case TYPE_FLOAT:
				for(i=0;i<(m2->dimension * m2->dimension);i++)
					m2->matrice.matFloat[i] = (float) m->matrice.matInt[i];
				break;
			default:
				exit(EXIT_FAILURE);
				break;
		}
	}
}

// AFFICHAGE DE LA MATRICE
void afficherMatrice(const Matrice *m){
	if(m==NULL || (m->matrice.matInt == NULL && m->matrice.matFloat == NULL)){exit(EXIT_FAILURE);}
	int i,j;
	printf("[");
	switch(m->type){
		case TYPE_INT:
			for(i=0;i<m->dimension;i++){
				for(j=0;j<m->dimension;j++){
					printf("%d",m->matrice.matInt[i*m->dimension+j]);
					if(j!=(m->dimension-1))
						printf(" ");
				}
				printf("]");
				if(i!=(m->dimension-1))
					printf("\n");
			}	
			break;
		case TYPE_FLOAT:
			for(i=0;i<m->dimension;i++){
				for(j=0;j<m->dimension;j++){
					printf("%f",m->matrice.matFloat[i*m->dimension+j]);
					if(j!=(m->dimension-1))
						printf(" ");
				}
				printf("]");
				if(i!=(m->dimension-1))
					printf("\n");
			}
			break;
		default:
			exit(EXIT_FAILURE);
			break;
	}
	printf("]\n");
}

// ADDITION DE MATRICE
Matrice *addMatrice(const Matrice *m1,const Matrice *m2,typeMat typeMatriceSortie){
	Matrice *answer = NULL;
	Matrice *m1CP = cpMatrice(m1), *m2CP = cpMatrice(m2);
	swapTypeMatrice(m1CP,typeMatriceSortie);
	swapTypeMatrice(m2CP,typeMatriceSortie);
	switch(typeMatriceSortie){
		case TYPE_INT:
			answer=addMatrice_INT(m1CP,m2CP);
			break;
		case TYPE_FLOAT:
			answer=addMatrice_FLOAT(m1CP,m2CP);
			break;
		default:
			exit(EXIT_FAILURE);
			break;
	}
	return answer;
}

Matrice *addMatrice_INT(const Matrice *m1,const Matrice *m2){
	if(m1 == NULL || m2 == NULL || m1->matrice.matInt == NULL || m2->matrice.matInt == NULL || m1->dimension != m2->dimension){exit(EXIT_FAILURE);}
	Matrice *answer = initialiserMatrice(m1->dimension,TYPE_INT);
	if(answer==NULL || answer->matrice.matInt == NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<(m1->dimension*m1->dimension);i++)
		answer->matrice.matInt[i] = m1->matrice.matInt[i] + m2->matrice.matInt[i];
	return answer;
}

Matrice *addMatrice_FLOAT(const Matrice *m1,const Matrice *m2){
	if(m1 == NULL || m2 == NULL || m1->matrice.matFloat == NULL || m2->matrice.matFloat == NULL || m1->dimension != m2->dimension){exit(EXIT_FAILURE);}
	Matrice *answer = initialiserMatrice(m1->dimension,TYPE_FLOAT);
	if(answer==NULL || answer->matrice.matFloat == NULL){exit(EXIT_FAILURE);}
	int i;
	for(i=0;i<(m1->dimension*m1->dimension);i++)
		answer->matrice.matFloat[i] = m1->matrice.matFloat[i] + m2->matrice.matFloat[i];
	return answer;
}

//MULTIPLICATION PAR UNE VARIABLE
//Matrice *multVarMatrice_FLOAT
