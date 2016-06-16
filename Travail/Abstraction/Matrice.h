#ifndef MATRICE_H_INCLUDED
#define MATRICE_H_INCLUDED

#include "MatriceCPU.h"
#include "MatriceGPU.h"

enum typeMemoire{CPU,GPU};
typedef enum typeMemoire typeMemoire;

typedef struct Matrice Matrice;
struct Matrice{
	MatriceCPU *matriceCPU;
	MatriceGPU *matriceGPU;
	unsigned long dimension;
	typeMemoire memoryUsed;
};//Definition du type matrice

Matrice *initialiserMatrice(const unsigned long taille);// Initialise une matrice non spécifié de dimension taille*taille
void freeMatrice(Matrice *); // Libère une matrice
void initialiserSubMatrice(Matrice *m,typeMemoire memory);// Initialise une sous matrice sur l'espace mémoire spécifié
void remplirMatrice(Matrice *m);// Remplis aléatoirement une matrice
void swapMemoryUse(Matrice *m,typeMemoire mem);//Change le type de mémoire utilisé en celui spécifié (place la matrice dans la case mémoire correspondante)

void additionMatrice(Matrice *m1,Matrice *m2,Matrice *resultat);//Fais l'opération sur l'emplacement mémoire de résultat
void multiplicationMatrice(Matrice *m1,Matrice *m2,Matrice *resultat);//Fais l'opération sur l'emplacement mémoire de résultat

int dimEqual(Matrice *,Matrice *);// Renvoie 1 si les matrices sont de dimensions égales

#endif //MATRICE_H_INCLUDED
