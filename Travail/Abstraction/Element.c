#include <stdlib.h>

#include "Element.h"

Element additionElement(const Element a,const Element b){return a+b;}
Element multiplicationElement(const Element a,const Element b){return a*b;}
int equalElement(const Element a,const Element b){return a==b;}
int noneEqualElement(const Element a,const Element b){return !(equalElement(a,b));}
Element randomElement(){return rand();}
