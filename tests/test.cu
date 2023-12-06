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

#define SIZE 1000
#define TOLERANCE 1.0 / SIZE * 100

/**
 * @brief Test the size of the vector
 * 
 */
void check_size()
{
    cout << "Testing the size of the vector" << endl;
    std::vector<double> BM;

    BMG::generate_default_BM(SIZE, BM);

    CU_ASSERT_EQUAL(BM.size(), SIZE);
}

void isNormalIncrement()
{
    cout << "Testing the normality of the increment" << endl;
    std::vector<double> BM;

    BMG::generate_default_BM(SIZE, BM);

    std::vector<double> increments;
    for (int i = 1; i < SIZE; i++)
    {
        increments.push_back(BM[i] - BM[i - 1]);
    }

    double mean = 0;
    for (int i = 0; i < SIZE - 1; i++)
    {
        mean += increments[i];
    }
    mean /= SIZE - 1;

    double variance = 0;
    for (int i = 0; i < SIZE - 1; i++)
    {
        variance += (increments[i] - mean) * (increments[i] - mean);
    }

    variance /= SIZE - 1;

    cout << "Mean : " << mean << endl;
    cout << "Variance : " << variance << endl;

    CU_ASSERT_DOUBLE_EQUAL(mean, 0, TOLERANCE);
    CU_ASSERT_DOUBLE_EQUAL(variance, 1, TOLERANCE);
}

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
    CU_ADD_TEST(pSuite, check_size);
    CU_ADD_TEST(pSuite, isNormalIncrement);

    CU_basic_set_mode(CU_BRM_VERBOSE);
    CU_basic_run_tests();

    CU_cleanup_registry();
    return 0;
}