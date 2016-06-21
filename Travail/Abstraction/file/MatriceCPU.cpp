#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "DEBUG.h"

#include "Element.h"
#include "MatriceCPU.h"

inline static unsigned int positionElement(const unsigned int i,const unsigned int j,const MatriceCPU *m){return i*m->dimension+j;}

inline static void pointeurNonAlloue(const void *pointeur){if(pointeur == NULL){exit(42);}}

inline void matriceNonInitialiseCPU(const MatriceCPU *pointeur){pointeurNonAlloue(pointeur);pointeurNonAlloue(pointeur->matrice);}


#ifdef ENABLE_DEBUG
inline static void matriceDimEqual(const MatriceCPU *m1,const MatriceCPU *m2){if(m1->dimension != m2->dimension){exit(EXIT_FAILURE);}}

inline static void matriceNonInitialise2mat(const MatriceCPU *m1,const MatriceCPU *m2){matriceNonInitialise(m1);matriceNonInitialise(m2);}

inline static void matriceNonInitialise3mat(const MatriceCPU *m1,const MatriceCPU *m2,const MatriceCPU *m3){matriceNonInitialise(m1);matriceNonInitialise(m2);matriceNonInitialise(m3);}

inline static void matriceDimEqual3mat(const MatriceCPU *m1,const MatriceCPU *m2,const MatriceCPU *m3){matriceDimEqual(m1,m2);matriceDimEqual(m1,m3);}

inline static void calculPossible2mat(const MatriceCPU *m1,const MatriceCPU *m2){matriceDimEqual(m1,m2);matriceNonInitialise2mat(m1,m2);}

inline static void calculPossible3mat(const MatriceCPU *m1,const MatriceCPU *m2,const MatriceCPU *m3){matriceDimEqual3mat(m1,m2,m3);matriceNonInitialise3mat(m1,m2,m3);}
#endif

MatriceCPU *initialiserMatriceCPU(const unsigned long taille){
	const unsigned long qtMemory=taille*taille*sizeof(Element);
	MatriceCPU *m= (MatriceCPU *) malloc(sizeof(MatriceCPU));
	pointeurNonAlloue(m);
	m->matrice=(Element *) malloc(qtMemory);
	pointeurNonAlloue(m->matrice);
	m->dimension = taille;
	return m;
}

void freeMatriceCPU(MatriceCPU *m){
	if(m!=NULL){
		free(m->matrice);
		free(m);
		m=NULL;
	}
}

void additionMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2, const MatriceCPU *resultat){
	DEBUG(calculPossible3mat(m1,m2,resultat);)
	for(int i=0;i<m1->dimension;i++){
		for(int j=0;j<m1->dimension;j++)
			resultat->matrice[positionElement(i,j,resultat)]=additionElement(m1->matrice[positionElement(i,j,m1)],m2->matrice[positionElement(i,j,m2)]);
	}
}

void multiplicationMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2,MatriceCPU *resultat){
	DEBUG(calculPossible3mat(m1,m2,resultat);)
	
	Element tmp;
	for(int i=0;i<m1->dimension;i++){
		for(int j=0;j<m1->dimension;j++){
			tmp=ZERO_ELEMENT;
			for(int k=0;k<m1->dimension;k++)
				tmp=additionElement(tmp,multiplicationElement(m1->matrice[i*m1->dimension+k],m2->matrice[k*m1->dimension +j]));
			resultat->matrice[positionElement(i,j,resultat)]=tmp;
		}
	}
}

int matriceEqualCPU(const MatriceCPU *m1,const MatriceCPU *m2){
	DEBUG(calculPossible2mat(m1,m2);)
	
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

void fillRandomMatriceCPU(MatriceCPU *m){
	DEBUG(matriceNonInitialise(m);)
	for(int i=0;i<m->dimension;i++){
		for(int j=0;j<m->dimension;j++)
			m->matrice[positionElement(i,j,m)] = randomElement();	
	}
}
