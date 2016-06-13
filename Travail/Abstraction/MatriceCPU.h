#ifndef MATRICECPU_H_INCLUDED
#define MATRICECPU_H_INCLUDED

typedef struct MatriceCPU MatriceCPU;
struct MatriceCPU{
	Element* matrice;//tableau linéaire représentant une matrice à 2 dimension
	unsigned long dimension;//longueur de chaque coté de la matrice
};//Definition du type matrice

MatriceCPU *initialiserMatriceCPU(const unsigned long taille); //Initialise une matrice de dimension taille*taille dans la RAM
void freeMatriceCPU(MatriceCPU *); //Mibere une matrice enregistre dans la RAM

void additionMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2, const MatriceCPU *resultat); //Additionne m1 et m2, et stocke dans resultat
void multiplicationMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2,MatriceCPU *resultat);//Multiplie m1 et m2, et stocke dans resultat

int matriceEqualCPU(const MatriceCPU *m1,const MatriceCPU *m2);//Renvoie 1 si m1 et m2 sont de valeurs égales, sinon 0

void fillRandomMatriceCPU(MatriceCPU *m);//Remplie la matrice m d'Element aléatoire

void matriceNonInitialiseCPU(const MatriceCPU *);//Test si la matrice est initialise et utilisable

#endif //MATRICECPU_H_INCLUDED
