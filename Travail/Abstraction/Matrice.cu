#include <stdlib.h>

#include "Element.h"
#include "Matrice.h"

inline static void pointeurNonAlloue(const void *pointeur){if(pointeur == NULL){exit(126);}}

int dimEqual(const Matrice *m1,const Matrice *m2){return m1->dimension==m2->dimension;}

inline static void cpMatriceSub(const Element *original,Element *copie,const unsigned long taille){
	for(int i=0;i<taille*taille;i++)
		copie[i]=original[i];
}
/*
inline static int equalMatriceSub(const Element *matriceCPU,Element *matriceGPU,const unsigned long taille){
	int answer = 1,i=0;
	while(!answer && i<taille*taille){
		answer = (matriceCPU[i]==matriceGPU[i]);
		i++;
	}
	return answer;
}
*/
Matrice *initialiserMatrice(const unsigned long taille){
	Matrice *m = (Matrice *) malloc(sizeof(Matrice));
	pointeurNonAlloue(m);
	m->matriceCPU=NULL;
	m->matriceGPU=NULL;
	m->dimension=taille;
	return m;
}

void freeMatrice(Matrice *m){
	if(m!=NULL){
		freeMatriceCPU(m->matriceCPU);
		freeMatriceGPU(m->matriceGPU);
		free(m);
		m=NULL;
	}
}

void remplirMatrice(Matrice *m,typeMemoire memory){
	switch(memory){
		case CPU:
			m->matriceCPU=initialiserMatriceCPU(m->dimension);
			fillRandomMatriceCPU(m->matriceCPU);
			break;
		case GPU:
			m->matriceGPU=initialiserMatriceGPU(m->dimension);
			fillRandomMatriceGPU(m->matriceGPU);
			break;
	}
	m->memoryUsed=memory;
}

void swapMemoryUse(Matrice *m,typeMemoire mem){
	if(mem!=m->memoryUsed){
		switch(m->memoryUsed){
			case CPU:
				if(m->matriceGPU==NULL)
					m->matriceGPU = initialiserMatriceGPU(m->dimension);
				cpMatriceSub((m->matriceCPU)->matrice,(m->matriceGPU)->matrice,m->dimension);
				break;
			case GPU:
				if(m->matriceCPU==NULL)
					m->matriceCPU = initialiserMatriceCPU(m->dimension);
				cpMatriceSub((m->matriceGPU)->matrice,(m->matriceCPU)->matrice,m->dimension);
				break;
		}
		m->memoryUsed=mem;
	}
}

void additionMatrice(Matrice *m1,Matrice *m2,Matrice *resultat){
	typeMemoire memM1=m1->memoryUsed,memM2=m2->memoryUsed,memRes=resultat->memoryUsed;
	swapMemoryUse(m1,memRes);
	swapMemoryUse(m2,memRes);
	switch(resultat->memoryUsed){
		case CPU:
			additionMatriceCPU(m1->matriceCPU,m2->matriceCPU,resultat->matriceCPU);
			break;
		case GPU:
			additionMatriceGPU(m1->matriceGPU,m2->matriceGPU,resultat->matriceGPU);
			break;
	}
	m1->memoryUsed=memM1;
	m2->memoryUsed=memM2;
}

void multiplicationMatrice(Matrice *m1,Matrice *m2,Matrice *resultat){
	typeMemoire memM1=m1->memoryUsed,memM2=m2->memoryUsed,memRes=resultat->memoryUsed;
	swapMemoryUse(m1,memRes);
	swapMemoryUse(m2,memRes);
	switch(resultat->memoryUsed){
		case CPU:
			multiplicationMatriceCPU(m1->matriceCPU,m2->matriceCPU,resultat->matriceCPU);
			break;
		case GPU:
			multiplicationMatriceGPU(m1->matriceGPU,m2->matriceGPU,resultat->matriceGPU);
			break;
	}
	m1->memoryUsed=memM1;
	m2->memoryUsed=memM2;
}
