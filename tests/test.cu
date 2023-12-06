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
#include "dbmg.h"
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

    CU_initialize_registry();

    CU_pSuite pSuite = CU_add_suite("Default Brownian motion", 0, 0);
    CU_ADD_TEST(pSuite, Tests::DBMG::check_size);
    CU_ADD_TEST(pSuite, Tests::DBMG::isNormalIncrement);

    CU_basic_set_mode(CU_BRM_VERBOSE);
    CU_basic_run_tests();

    CU_cleanup_registry();
    return 0;
}