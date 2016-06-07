#ifndef LIBMATGPU_H_INCLUDED
#define LIBMATGPU_H_INCLUDED

void multGPU1_Square(const float *M,const float *N,float *P,const int Width);
float* iniSquareGPU(const float *M,const int taille);
__global__ void multGPU1_Square_aux(float *Mg,float *Ng,float *Pg,int Width);

#endif //LIBMATGPU_H_INCLUDED
