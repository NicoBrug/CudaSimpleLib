#ifndef KERNEL_CUH__
#define KERNEL_CUH__

#include <stdio.h>

__declspec(dllexport)  void add(int* c, const int* a, const int* b, int size);

#endif