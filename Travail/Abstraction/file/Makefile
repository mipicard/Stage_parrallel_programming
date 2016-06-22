CC=nvcc
# Rajoutez -DGPU_OPTI pour TestVitesse2,-DGPU_OPTI_M pour TestVitesse3
CFLAGS=-g -DGPU_OPTI_M
#Renommez en TestVitesse2 ou TestVitesse3 si nécessaire, sinon laisser TestVitesse1
TARGET=../TestVitesse3

all : $(TARGET)

$(TARGET) : main.o Element.o Matrice.o MatriceCPU.o MatriceGPU.o Timer.o
	$(CC) -o $@ $^ $(CFLAGS)

%.o: %.cu
	$(CC) -c $^ $(CFLAGS) -o $@

%.o: %.cpp
	$(CC) -c $^ $(CFLAGS) -o $@

clean :
	rm -f *.o

mrproper : clean
	rm -f $(TARGET)

dist: $(wildcard *.cpp *.cu *.h *.sh) Makefile
	tar cvzf Matrices.tgz $^
