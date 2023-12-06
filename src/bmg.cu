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

    if (cuda && N > std::thread::hardware_concurrency())
    {
        
    }
    else
    {
#ifdef OMP_ENABLED
        #pragma omp parallel for
        for (size_t i = 0; i < N; i++)
        {
            generate_default_BM(n, BM[i], start);
        }
#else
        std::thread *threads = new std::thread[N];
        for (size_t i = 0; i < N; i++)
        {
            threads[i] = std::thread([n, &BM, start, i]() {
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