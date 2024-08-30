#include <iostream>
#include <stdio.h>
#include <stdio.h>
#include <assert.h>
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;


// Kernel
__global__ 
void cuda_hello(){

    int idx = threadIdx.x;

    printf("identity: %d \n",idx);
    printf("Hello World from GPU! %d\n",idx);
    //cout << "Hello World cout GPU!" <<  "\n";
    //std::cout << "Hello World cout GPU!" << "\n";
}


// Main
int main() {
    printf("Hello World Start from CPU!\n");
    
    cuda_hello<<<1,1>>>();
    cudaDeviceSynchronize();

    printf("Hello World End from CPU!\n");
    return 0;
}