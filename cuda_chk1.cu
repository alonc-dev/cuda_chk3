#include <iostream>
#include <stdio.h>

// Kernel
__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
    
}

// Main
int main() {
    printf("Hello World from CPU!\n");
    
    cuda_hello<<<1,1>>>(); 
    return 0;
}