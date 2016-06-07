#ifndef LIBMAT_H_INCLUDED
#define LIBMAT_H_INCLUDED

float* iniSquare(const int dim);
void multCPU1_Square(const float *M,const float *N,float *P,const int Width);
void afficheMatriceSquare(const float *mat, const int Width);
void askValueMatriceSquare(float* mat,const int Width, const int r);
void ask(float *M,float *N,const int width,const int r,const int a);
void usage();
void defArg(const int argc,char* argv[], int *w, int *r,int* a);
int max2Int(const int a,const int b);
int equalSquareMatrix(const float *mat1,const float *mat2,const int Width);

#endif // LIBMAT_H_INCLUDED
