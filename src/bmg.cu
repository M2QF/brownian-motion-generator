/**
 * @file bmg.cu
 * @author AiglonDore
 * @brief Implements {@link bmg.h}
 * @version 0.1
 * @date 2023-12-06
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include "../header/bmg.h"
#include <random>
#include <omp.h>
#include <cuda_runtime.h>
#include <cuda.h>
#include <curand_kernel.h>
#include <thread>

using namespace BMG;

namespace std {
    size_t min(int a, size_t b)
    {
        if (a < 0)
            return 0;
        return (a < b) ? a : b;
    }
}

namespace CUDA{
    namespace Kernel {
        __global__ void generate_BM_kernel(double** BM, std::size_t n, double start, int offset)
        {
            int tid = blockIdx.x * blockDim.x + threadIdx.x;
            curandState state;

            curand_init(clock64(), tid + offset, 0, &state);
            
            BM[threadIdx.x + offset][0] = start;

            for (size_t i = 1; i < n; i++)
            {
                BM[threadIdx.x + offset][i] = BM[threadIdx.x + offset][i - 1] + curand_normal_double(&state);
            }
        }
    }

    void generate_default_BMs_on_cuda(std::size_t n, std::vector<std::vector<double>>& BM, std::size_t N, double start)
    {
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, 0);

        int nb_max_thread = prop.maxThreadsPerBlock;

        double** d_BM;
        cudaMalloc((void**)&d_BM, N * sizeof(double*));
        for (size_t i = 0; i < N; i++)
        {
            BM[i].resize(n);
            cudaMalloc((void**)&d_BM[i], n * sizeof(double));
        }

        for (int i = 0; i < N / nb_max_thread + 1; i++)
            CUDA::Kernel::generate_BM_kernel<<<1, std::min(nb_max_thread, N)>>>(d_BM, n, start, i * nb_max_thread);

        for (size_t i = 0; i < N; i++)
        {
            cudaMemcpy(BM[i].data(), d_BM[i], n * sizeof(double), cudaMemcpyDeviceToHost);
            cudaFree(d_BM[i]);
        }
        cudaFree(d_BM);
        d_BM = nullptr;
    }
}

void BMG::generate_default_BM(std::size_t n, std::vector<double>& BM, double start)
{
    BM.resize(n);
    BM[0] = start;

    std::random_device rd;
    std::mt19937 gen(rd());
    std::normal_distribution<double> d(0, 1);

    for (size_t i = 1; i < n; i++)
    {
        BM[i] = BM[i - 1] + d(gen);
    }

    BM.shrink_to_fit();
}

void BMG::generate_default_BM(std::size_t n, std::vector<std::vector<double>>& BM, std::size_t N, double start, bool cuda)
{
    BM.resize(N);
    int nb_GPU(0);
    if (cuda && N > std::thread::hardware_concurrency() && cudaGetDeviceCount(&nb_GPU) == cudaSuccess && nb_GPU > 0)
    {
        CUDA::generate_default_BMs_on_cuda(n, BM, N, start);
    }
    else
    {
#ifdef _OPENMP
        #pragma omp parallel for
        for (size_t i = 0; i < N; i++)
        {
            generate_default_BM(n, BM[i], start);
        }
#else
        std::thread *threads = new std::thread[N];
        for (size_t i = 0; i < N; i++)
        {
            threads[i] = std::thread([n, &BM, start, i](void) -> void {
                BMG::generate_default_BM(n, BM[i], start);
            });
        }
        for (size_t i = 0; i < N; i++)
        {
            threads[i].join();
        }

        delete[] threads;
        threads = nullptr;
#endif
    }
    
    BM.shrink_to_fit();
}