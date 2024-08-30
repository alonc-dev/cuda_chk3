#include <iostream>
#include <stdio.h>

// Kernel
__global__ void cuda_hello(){
    printf("Hello World from GPU (Device)!\n");
}

// Kernel definition
__global__ void VecAdd(float* A, float* B, float* C)
{
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
}

__global__ void get_idx(int n, float a, float *x, float *y)
{

    int thIdx_x = threadIdx.x;
    int blIdx_x = blockIdx.x;
    int blDim_x = blockDim.x;

    int thIdx_y = threadIdx.y;
    int blIdx_y = blockIdx.y;
    int blDim_y = blockDim.y;

    int thIdx_z = threadIdx.z;
    int blIdx_z = blockIdx.z;
    int blDim_z = blockDim.z;

    printf("Running from GPU (Device) %d,%d,%d!\n",thIdx_x,blIdx_x,blDim_x);
    
    int i = thIdx_x*blIdx_x + blDim_x;
    if (i < n){
        x[i] = a;
        y[i] = (float)thIdx_x;
    }

    x[0]=2.5;
    y[0]=2.5;
}



// Main
int main() {

    printf("Start running on CPU (Host)!\n");

    int N = 1<<5;
    float *a, *b, *c;
    float *d_a, *d_b, *d_c;

    // create x,y arr at host
    a = (float*)malloc(N*sizeof(float));
    b = (float*)malloc(N*sizeof(float));
    c = (float*)malloc(N*sizeof(float));

    // create d_x, d_y arr at the device
    cudaMalloc(&d_a, N*sizeof(float)); 
    cudaMalloc(&d_b, N*sizeof(float));
    cudaMalloc(&d_c, N*sizeof(float));

    for (int i = 0; i < N; i++) {
        a[i] = 1.0f;
        b[i] = 2.0f;
        c[i] = 3.0f;
    }

    // copy arr from host to device
    cudaMemcpy(d_a, a, N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_c, c, N*sizeof(float), cudaMemcpyHostToDevice);

    // Kernel invocation with N threads
    VecAdd<<<1, N>>>(a, b, c);
    // get_idx<<<(N+255)/256, 256>>>(N, 7.5f, d_x, d_y);

    // copy arr from device to host
    cudaMemcpy(a, d_a, N*sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(b, d_b, N*sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(c, d_c, N*sizeof(float), cudaMemcpyDeviceToHost);

    for (int i = 0; i < N; i++) {
        printf("%2d) a,b,c       = %f, %f, %f\n", i, a[i], b[i], c[i]);
        printf("%2d) d_a,d_b,d_c = %f, %f, %f\n", i, d_a[i], d_b[i], d_c[i]);
    }
    
    printf("End Running on CPU (Host)!\n");

    return 0;
}