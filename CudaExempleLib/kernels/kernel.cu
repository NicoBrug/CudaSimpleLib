#include "kernel.cuh"
#include "stdio.h"

#define N 10

__global__ void kernel_add(int* c, int* a, int* b, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

// Helper function for using CUDA to add vectors in parallel.
void add(int* c, const int* a, const int* b, int size) {
    int* dev_a = nullptr;
    int* dev_b = nullptr;
    int* dev_output = nullptr;

    // Allocate GPU buffers for three vectors (two input, one output)
    cudaMalloc((void**)&dev_a, size * sizeof(int));
    cudaMalloc((void**)&dev_b, size * sizeof(int));
    cudaMalloc((void**)&dev_output, size * sizeof(int));

    // Copy input vectors from host memory to GPU buffers.
    cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);

    kernel_add << <2, (size + 1) / 2 >> > (dev_output, dev_a, dev_b, size);

    cudaDeviceSynchronize();

    // Copy output vector from GPU buffers to host memory
    cudaMemcpy(c, dev_output, size * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_output);
}