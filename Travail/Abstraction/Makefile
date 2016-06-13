MatriceCPU.o : MatriceCPU.c MatriceCPU.h Element.o DEBUG.h
	nvcc -c MatriceCPU.c Element.o

Element.o : Element.c Element.h
	nvcc -c Element.c
	
MatriceGPU.o : MatriceGPU.cu MatriceGPU.h Element.o DEBUG.h
	nvcc -c MatriceGPU.cu Element.o
