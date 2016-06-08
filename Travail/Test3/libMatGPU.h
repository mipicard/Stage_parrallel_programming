#ifndef LIBMATGPU_H_INCLUDED
#define LIBMATGPU_H_INCLUDED


float* iniSquareGPU(const float *M,const int taille);
void multGPU1_Square(const float *M,const float *N,float *P,const int Width);
__global__ void multGPU1_Square_aux(float *Mg,float *Ng,float *Pg,int Width);

void multGPU2_Square(const float *M,const float *N,float *P,const int Width);
__global__ void multGPU2_Square_aux(float *Mg,float *Ng,float *Pg,int Width,int nbThreadPerBlock);
int divMaxDim(const int dim);

#endif //LIBMATGPU_H_INCLUDED
