#include <stdlib.h>

#include "Element.h"


//__host__ __device__ Element additionElement(const Element a,const Element b){return a+b;}
//__host__ __device__ Element multiplicationElement(const Element a,const Element b){return a*b;}
int equalElement(const Element a,const Element b){return a==b;}
Element randomElement(){return rand();}
