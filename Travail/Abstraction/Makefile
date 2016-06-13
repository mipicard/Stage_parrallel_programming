Matrice.o : Matrice.cu Matrice.h MatriceCPU.o MatriceGPU.o Element.o DEBUG.h
	nvcc -c Matrice.cu MatriceCPU.o MatriceGPU.o Element.o

MatriceCPU.o : MatriceCPU.c MatriceCPU.h Element.o DEBUG.h
	nvcc -c MatriceCPU.c Element.o

MatriceGPU.o : MatriceGPU.cu MatriceGPU.h Element.o DEBUG.h
	nvcc -c MatriceGPU.cu Element.o

Element.o : Element.c Element.h
	nvcc -c Element.c
