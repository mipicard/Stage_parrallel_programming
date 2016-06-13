#ifndef MATRICEGPU_H_INCLUDED
#define MATRICEGPU_H_INCLUDED

typedef struct MatriceGPU MatriceGPU;
struct MatriceGPU{
	Element* matrice;//tableau linéaire représentant une matrice à 2 dimension
	unsigned long dimension;//longueur de chaque coté de la matrice
};//Definition du type matrice

MatriceGPU *initialiserMatriceGPU(const unsigned long taille); //Initialise une matrice de dimension taille*taille dans la RAM
void freeMatriceGPU(MatriceGPU *); //Mibere une matrice enregistre dans la RAM

//void additionMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2, const MatriceGPU *resultat); //Additionne m1 et m2, et stocke dans resultat
//void multiplicationMatriceGPU(const MatriceGPU *m1,const MatriceGPU *m2,MatriceGPU *resultat);//Multiplie m1 et m2, et stocke dans resultat

int matriceEqualGPU(const MatriceGPU *m1,const MatriceGPU *m2);//Renvoie 1 si m1 et m2 sont de valeurs égales, sinon 0

void fillRandomMatriceGPU(MatriceGPU *m);//Remplie la matrice m d'Element aléatoire

void matriceNonInitialiseGPU(const MatriceGPU *);//Test si la matrice est initialise et utilisable

#endif //MATRICEGPU_H_INCLUDED
