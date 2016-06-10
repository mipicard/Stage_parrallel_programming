#ifndef MATRICECPU_H_INCLUDED
#define MATRICECPU_H_INCLUDED

typedef struct MatriceCPU MatriceCPU;
struct MatriceCPU{
	Element* matrice;
	unsigned long dimension;
};

MatriceCPU *initialiserMatriceCPU(const unsigned long taille); //Initialise une matrice de dimension taille*taille dans la RAM
void freeMatriceCPU(MatriceCPU *); //Mibere une matrice enregistre dans la RAM

void additionMatriceCPU(const MatriceCPU *m1,const MatriceCPU *m2, const MatriceCPU *resultat); //Additionne m1 et m2 et stocke dans resultat

#endif //MATRICECPU_H_INCLUDED
