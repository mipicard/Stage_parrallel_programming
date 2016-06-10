#ifndef MATRICESQUARE_H_INCLUDED
#define MATRICESQUARE_H_INCLUDED

enum typeMat{TYPE_INT,TYPE_FLOAT};
typedef enum typeMat typeMat;

typedef struct Matrice Matrice;
struct Matrice{
	union{
		int *matInt;
		float *matFloat;
	}matrice;
	typeMat type;
	int dimension;
};

Matrice* initialiserMatrice(const int taille,const int type);
Matrice* initialiserMatrice_INT(const int taille);
Matrice* initialiserMatrice_FLOAT(const int taille);

void matriceRaZ(Matrice *m);
void matriceRaZ_INT(Matrice *m);
void matriceRaZ_FLOAT(Matrice *m);

Matrice *cpMatrice(const Matrice *m);
Matrice *cpMatrice_INT(const Matrice *m);
Matrice *cpMatrice_FLOAT(const Matrice *m);

void freeMatrice(Matrice *m);
void freeMatrice_INT(Matrice *m);
void freeMatrice_FLOAT(Matrice *m);

void swapTypeMatrice(Matrice *m,const typeMat type);

void afficherMatrice(const Matrice *m);

Matrice *addMatrice(const Matrice *m1,const Matrice *m2,typeMat typeMatriceSortie);
Matrice *addMatrice_INT(const Matrice *m1,const Matrice *m2);
Matrice *addMatrice_FLOAT(const Matrice *m1,const Matrice *m2);

#endif // MATRICESQUARE_H_INCLUDED
