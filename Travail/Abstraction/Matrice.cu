#include <stdlib.h>

#include "MatriceCPU.h"
#include "MatriceGPU.h"
#include "Matrice.h"

inline static void pointeurNonAlloue(const void *pointeur){if(!(pointeur == NULL)){exit(42);}}

Matrice *initialiserMatrice(){
	Matrice *m = (Matrice *) malloc(sizeof(Matrice));
	pointeurNonAlloue(m);
	m->matriceCPU=NULL;
	m->matriceGPU=NULL;
	return m;
}
