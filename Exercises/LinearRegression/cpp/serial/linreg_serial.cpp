/***
 * File: linreg_serial.cpp
 * Description: Linear Regression using grid search
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Wednesday, 9th March 2022, 2:26:13 pm
 * Last Modified: Wednesday, 9th March 2022, 2:26:17 pm
 *
 * Copyright (c) 2022, Bruno R. de Abreu, National Center for Supercomputing Applications.
 * All rights reserved.
 * License: This program and the accompanying materials are made available to any individual
 *          under the citation condition that follows: On the event that the software is
 *          used to generate data that is used implicitly or explicitly for research
 *          purposes, proper acknowledgment must be provided in the citations section of
 *          publications. This includes both the author's name and the National Center
 *          for Supercomputing Applications. If you are uncertain about how to do
 *          so, please check this page: https://github.com/babreu-ncsa/cite-me.
 *          This software cannot be used for commercial purposes in any way whatsoever.
 *          Omitting this license when redistributing the code is strongly disencouraged.
 *          The software is provided without warranty of any kind. In no event shall the
 *          author or copyright holders be liable for any kind of claim in connection to
 *          the software and its usage.
 ***/

#include <iostream>
#include <cmath>
#include <vector>

using namespace std;

int main()
{
    // parameter map
    int na = 10, nb = 10;      // number of points for each parameter in grid space
    double da = 0.1, db = 0.1; // grid spacing in each direction
    vector<double> a, b;       // parameters in each direction

    // target straight line
    int n = 1 << 23;           // number of "data" points
    vector<double> x;          // control variable
    double dx;                 // control variable spacing
    vector<double> y;          // response variable
    double at = 0.5, bt = 0.5; // target parameters

    // metrics
    double rss;         // residual sum of squares
    vector<double> mse; // mean squared error
    double best_mse;    // best mse

    // random numbers
    double rand1, rand2; // hold random numbers
    double z;            // Box-Muller transform
    double pi;           // PI
    pi = 4.0 * atan(1.0);

    // integer helpers
    int i, j, k; // loops
    int counter;
    int best_i, best_j;
    // double helpers
    double as, bs; // search parameters
    double ys;     // estimate of y using as, bs
    double xp, yp; // temporary variables (p from prime)

    // 1. Build parameter map - square grid in (a,b) space
    for (i = 0; i < na; i++)
    {
        a.push_back((i + 1) * da);
    }
    for (j = 0; j < nb; j++)
    {
        b.push_back((j + 1) * db);
    }

    // start random number generator
    srand(0);

    // 2. Build points to fit (dataset)
    dx = 1.0 / double(n); // we'll make x go from 0 to 1
    for (i = 0; i < n; i++)
    {
        xp = i * dx;
        yp = at * xp + bt;                                   // target y = at*x + bt
        rand1 = (double)rand() / RAND_MAX;                   // uniform random number 1
        rand2 = (double)rand() / RAND_MAX;                   // uniform random number 2
        z = sqrt(-2.0 * log(rand1)) * cos(2.0 * pi * rand2); // Box-Muller transformation
        yp = yp + z;                                         // add gaussian noise
        x.push_back(xp);
        y.push_back(yp);
    }

    // 3. Explore parameter space
    for (i = 0; i < na; i++)
    {
        as = a[i];
        for (j = 0; j < nb; j++)
        {
            bs = b[j];
            rss = 0.0;
            for (k = 0; k < n; k++)
            {
                ys = as * x[k] + bs;
                rss = rss + pow((ys - y[k]), 2.0);
            }
            mse.push_back(rss / n);
            cout << "(a,b) = (" << a[i] << "," << b[j] << ")      RSS = " << rss / n << endl;
        }
    }

    // 4. Look for best combination of (a,b)
    counter = 0;
    best_mse = mse[0];
    best_i = 0;
    best_j = 0;
    for (i = 0; i < na; i++)
    {
        for (j = 0; j < nb; j++)
        {
            if (mse[counter] < best_mse)
            {
                best_mse = mse[counter];
                best_i = i;
                best_j = j;
            }
            counter++;
        }
    }
    cout << "\n\nBest fit is for (a,b) = (" << a[best_i] << "," << b[best_j] << ")";
    cout << " with MSE = " << best_mse << endl;

    // clean up and good bye
    return 0;
}
