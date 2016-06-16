CC=nvcc
CFLAGS= -g
TARGET=TestVitesseCPU

all : $(TARGET)

$(TARGET) : main.o Element.o Matrice.o MatriceCPU.o MatriceGPU.o
	$(CC) -o $@ $^

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
