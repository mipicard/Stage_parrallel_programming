#ifndef ELEMENT_H_INCLUDED
#define ELEMENT_H_INCLUDED

#define ZERO_ELEMENT 0.0

typedef float Element;

Element additionElement(const Element,const Element);//Renvoie l'addition de a et b
Element multiplicationElement(const Element,const Element);//Renvoie la multiplication de a et b
int equalElement(const Element a,const Element b);//Renvoie 1 si a et b sont égaux, sinon 0
int noneEqualElement(const Element a,const Element b);// Renvoie 1 si a et b sont différents, sinon 0
Element randomElement();//Renvoie un element aléatoire NECESSITE L'INITIALISATION DE srand()

#endif //ELEMENT_H_INCLUDED
