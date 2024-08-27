#include <iostream>

// Kernel
__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
    
}

// Main
int main() {
    cuda_hello<<<1,1>>>(); 
    return 0;
}