/**
 * @file dbmg.h
 * @author AiglonDore
 * @brief Holds functions to test default Brownian motion generator
 * @version 1.0
 * @date 2023-12-06
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#pragma once

#include "constants.h"

/**
 * @brief Namespace for tests
 * 
 */
namespace Tests {
    /**
     * @brief Namespace for default Brownian motion generator tests
     * 
     */
    namespace DBMG {
        /**
         * @brief Checks if the size is correct
         * 
         */
        void check_size();
        /**
         * @brief Checks if the increments are normal
         * 
         */
        void isNormalIncrement();
    }
}