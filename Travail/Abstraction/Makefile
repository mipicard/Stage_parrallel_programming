CC=nvcc
CFLAGS=--compiler-options '-fPIC'
TARGET=TestVitesse

all : $(TARGET)

$(TARGET) : main.cu Matrice.so
	$(CC) $^ -o $@

Matrice.so : Matrice.cu Matrice.h MatriceCPU.o MatriceGPU.o Element.o DEBUG.h
	$(CC) -o $@ --shared $(CFLAGS) Matrice.cu MatriceCPU.o MatriceGPU.o Element.o

%.o: %.cu
	$(CC) -c $^ $(CFLAGS) -o $@

%.o: %.c
	$(CC) -c $^ $(CFLAGS) -o $@


clean :
	rm -f *.o

mrproper : clean
	rm -f $(TARGET) *.so
