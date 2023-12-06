/**
 * @file test.cu
 * @author AiglonDore
 * @brief Provides a test for the CUDA implementation of the algorithm
 * @version 1.0
 * @date 2023-12-06
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include "../header/bmg.h"
#include <CUnit/Basic.h>
#include <CUnit/CUnit.h>
#include <iostream>
#include <vector>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cstring>

using namespace std;

/**
 * @brief Test the CUDA implementation of the algorithm
 * 
 * @param argc 
 * @param argv 
 * @return int 
 */
int main(int argc, char **argv)
{
    CU_initialize_registry();
    bool GPU = true;
    for (int i = 0; i < argc; i++)
    {
        if (strcmp(argv[i], "--cpu") == 0)
        {
            cout << "Assuming that the machine has no GPU" << endl;
            cout << "Testing the CPU implementation" << endl;
            GPU = false;
        }
    }

    std::vector<double> BM;

    BMG::generate_default_BM(1000, BM);

    CU_ASSERT_EQUAL(BM.size(), 1000);

    CU_cleanup_registry();
    return 0;
}