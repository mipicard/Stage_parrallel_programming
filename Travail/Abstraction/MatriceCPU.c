#include <stdlib.h>
#include <string.h>

#include "Element.h"
#include "MatriceCPU.h"

void pointeurNonAlloue(const void *);
inline void pointeurNonAlloue(const void *pointeur){if(!(pointeur == NULL)){exit(EXIT_FAILURE);}}

void matriceNonInitialise(const MatriceCPU *);
inline void matriceNonInitialise(const MatriceCPU *pointeur){pointeurNonAlloue(pointeur);pointeurNonAlloue(pointeur->matrice);}

unsigned int positionElement(const unsigned int,const unsigned int,const unsigned long);
inline unsigned int positionElement(const unsigned int i,const unsigned int j,const unsigned long dimension){return i*dimension+j;}

MatriceCPU *initialiserMatriceCPU(const unsigned long taille){
	MatriceCPU *m= malloc(sizeof(MatriceCPU));
	pointeurNonAlloue(m);
	m->matrice=malloc(taille*taille*sizeof(Element));
	pointeurNonAlloue(m->matrice);
	memset(m->matrice,ZERO_ELEMENT,taille*taille*sizeof(Element));
	m->dimension = taille;
	return NULL;
}

void freeMatriceCPU(MatriceCPU *m){
	free(m->matrice);
	free(m);
	m=NULL;
}

void additionMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2, const MatriceCPU *resultat){
	matriceNonInitialise(m1);matriceNonInitialise(m2);matriceNonInitialise(resultat);
	
	for(int i=0;i<m1->dimension;i++){
		for(int j=0;j<m1->dimension;j++)
			resultat->matrice[positionElement(i,j,resultat->dimension)]=additionElement(m1->matrice[positionElement(i,j,m1->dimension)],m2->matrice[positionElement(i,j,m2->dimension)]);
	}
}
