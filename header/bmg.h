/**
 * @file bmg.h
 * @author AiglonDore
 * @brief Provides a namespace to generate Brownian Motion
 * @version 1.0
 * @date 2023-12-06
 *
 * @copyright Copyright (c) 2023
 *
 */

#pragma once

#include <vector>

/**
 * @brief Holds generators
 *
 */
namespace BMG
{
    /**
     * @brief Generates a Brownian Motion
     *
     * @param n Size
     * @param BM Brownian Motion output
     * @param start starting point
     */
    void generate_default_BM(std::size_t n, std::vector<double> &BM, double start = 0.0);
    /**
     * @brief Generates N Brownian Motions
     *
     * @param n Size
     * @param BM Output
     * @param N Number of Brownian Motions
     * @param start starting point
     * @param cuda Use CUDA to generate several Brownian Motions
     */
    void generate_default_BM(std::size_t n, std::vector<std::vector<double>> &BM, std::size_t N, double start = 0.0, bool cuda = true);
}