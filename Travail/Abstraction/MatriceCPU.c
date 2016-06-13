#include <stdlib.h>
#include <string.h>

#include "Element.h"
#include "MatriceCPU.h"


unsigned int positionElement(const unsigned int,const unsigned int,const MatriceCPU *);
inline unsigned int positionElement(const unsigned int i,const unsigned int j,const MatriceCPU *m){return i*m->dimension+j;}

void pointeurNonAlloue(const void *);
inline void pointeurNonAlloue(const void *pointeur){if(!(pointeur == NULL)){exit(EXIT_FAILURE);}}

void matriceNonInitialise(const MatriceCPU *);
inline void matriceNonInitialise(const MatriceCPU *pointeur){pointeurNonAlloue(pointeur);pointeurNonAlloue(pointeur->matrice);}

void matriceNonInitialise2mat(const MatriceCPU *,const MatriceCPU *);
inline void matriceNonInitialise2mat(const MatriceCPU *m1,const MatriceCPU *m2){matriceNonInitialise(m1);matriceNonInitialise(m2);}

void matriceNonInitialise3mat(const MatriceCPU *,const MatriceCPU *,const MatriceCPU *);
inline void matriceNonInitialise3mat(const MatriceCPU *m1,const MatriceCPU *m2,const MatriceCPU *m3){matriceNonInitialise(m1);matriceNonInitialise(m2);matriceNonInitialise(m3);}

void matriceDimEqual(const MatriceCPU *,const MatriceCPU *);
inline void matriceDimEqual(const MatriceCPU *m1,const MatriceCPU *m2){if(m1->dimension != m2->dimension){exit(EXIT_FAILURE);}}

void matriceDimEqual3mat(const MatriceCPU *,const MatriceCPU *,const MatriceCPU *);
inline void matriceDimEqual3mat(const MatriceCPU *m1,const MatriceCPU *m2,const MatriceCPU *m3){matriceDimEqual(m1,m2);matriceDimEqual(m1,m3);}

void calculPossible2mat(const MatriceCPU *,const MatriceCPU *);
inline void calculPossible2mat(const MatriceCPU *m1,const MatriceCPU *m2){matriceDimEqual(m1,m2);matriceNonInitialise2mat(m1,m2);}

void calculPossible3mat(const MatriceCPU *,const MatriceCPU *,const MatriceCPU *);
inline void calculPossible3mat(const MatriceCPU *m1,const MatriceCPU *m2,const MatriceCPU *m3){matriceDimEqual3mat(m1,m2,m3);matriceNonInitialise3mat(m1,m2,m3);}

MatriceCPU *initialiserMatriceCPU(const unsigned long taille){
	const unsigned long qtMemory=taille*taille*sizeof(Element);
	MatriceCPU *m= malloc(sizeof(MatriceCPU));
	pointeurNonAlloue(m);
	m->matrice=malloc(qtMemory);
	pointeurNonAlloue(m->matrice);
	memset(m->matrice,ZERO_ELEMENT,qtMemory);
	m->dimension = taille;
	return NULL;
}

void freeMatriceCPU(MatriceCPU *m){
	free(m->matrice);
	free(m);
	m=NULL;
}

void additionMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2, const MatriceCPU *resultat){
	calculPossible3mat(m1,m2,resultat);
	
	for(int i=0;i<m1->dimension;i++){
		for(int j=0;j<m1->dimension;j++)
			resultat->matrice[positionElement(i,j,resultat)]=additionElement(m1->matrice[positionElement(i,j,m1)],m2->matrice[positionElement(i,j,m2)]);
	}
}

void multiplicationMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2,MatriceCPU *resultat){
	calculPossible3mat(m1,m2,resultat);
	
	Element tmp;
	for(int i=0;i<m1->dimension;i++){
		for(int j=0;i<m1->dimension;i++){
			tmp=ZERO_ELEMENT;
			for(int k=0;k<m1->dimension;i++)
				tmp=additionElement(tmp,multiplicationElement(m1->matrice[i*m1->dimension+k],m2->matrice[k*m1->dimension +j]));
			resultat->matrice[positionElement(i,j,resultat)]=tmp;
		}
	}
}

int matriceEqualCPU(const MatriceCPU *m1,const MatriceCPU *m2){
	calculPossible2mat(m1,m2);
	
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

int noneMatriceEqualCPU(const MatriceCPU *m1,const MatriceCPU *m2){return !(matriceEqualCPU(m1,m2));}

void fillRandomMatriceCPU(MatriceCPU *m){
	matriceNonInitialise(m);
	
	for(int i=0;i<m->dimension;i++){
		for(int j=0;j<m->dimension;j++)
			m->matrice[positionElement(i,j,m)] = randomElement();		
	}
}
