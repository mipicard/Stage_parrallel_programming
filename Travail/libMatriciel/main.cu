#include <stdio.h>
#include <stdlib.h>

#include "MatriceSquare.h"

int main(int argv,char **argc){
	Matrice *m1 = initialiserMatrice(2,TYPE_INT), *m2 = initialiserMatrice(2,TYPE_FLOAT);
	afficherMatrice(m1);afficherMatrice(m2);
	return 0;
}
