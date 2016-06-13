#ifndef MATRICE_H_INCLUDED
#define MATRICE_H_INCLUDED

typedef struct Matrice Matrice;
struct Matrice{
	MatriceCPU *matriceCPU;
	MatriceGPU *matriceGPU;
	unsigned long dimension;
};//Definition du type matrice

#endif //MATRICE_H_INCLUDED
