/**
 * @file dbmg.cu
 * @author AiglonDore
 * @brief Implements {@link dbmg.h}
 * @version 1.0
 * @date 2023-12-06
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include "dbmg.h"
#include "../header/bmg.h"

#include <CUnit/Basic.h>
#include <CUnit/CUnit.h>
#include <iostream>
#include <vector>

using namespace std;

void Tests::DBMG::check_size()
{
    cout << "Testing the size of the vector" << endl;
    std::vector<double> BM;

    BMG::generate_default_BM(SIZE, BM);

    CU_ASSERT_EQUAL(BM.size(), SIZE);
}

void Tests::DBMG::isNormalIncrement()
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