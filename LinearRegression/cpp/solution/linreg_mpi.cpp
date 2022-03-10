/***
 * File: linreg_mpi.cpp
 * Description: MPI-parallelized Linear Regression using search grid
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Thursday, 10th March 2022, 8:27:09 am
 * Last Modified: Thursday, 10th March 2022, 8:27:11 am
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
#include <mpi.h>

using namespace std;

int main()
{
    // parameter map
    int na = 10, nb = 10;      // number of points for each parameter in grid space
    double da = 0.1, db = 0.1; // grid spacing in each direction
    vector<double> a, b;       // parameters in each direction

    // target straight line
    int n = 1 << 27;           // number of "data" points
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

    // MPI variables
    int myrank; // rank id
    int nranks; // total number of ranks
    int mpierr; // return from MPI calls

    // Distributed task variables
    int mychunksize;     // number of loop iterations for each PE
    int leftover;        // in case n is not divisible by the number of PEs
    int mystart, mystop; // each PE start and stop iteration values
    double worldrss;

    // start MPI
    mpierr = MPI_Init(NULL, NULL);
    // get number of ranks
    mpierr = MPI_Comm_size(MPI_COMM_WORLD, &nranks);
    // get each PE's id
    mpierr = MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

    // 1. Build parameter map - square grid in (a,b) space
    // We only want PE 0 to do this, no need for the others to know about it
    if (myrank == 0)
    {
        for (i = 0; i < na; i++)
        {
            a.push_back((i + 1) * da);
        }
        for (j = 0; j < nb; j++)
        {
            b.push_back((j + 1) * db);
        }
    }

    // start random number generator
    // each PE has a different seed
    srand(myrank);

    // 2. Build points to fit (dataset)
    dx = 1.0 / double(n); // we'll make x go from 0 to 1
    // We need to carefully distribute the correct loop interval to each PE
    // First, we find the chunk size
    mychunksize = n / nranks;
    leftover = n % nranks;
    if (myrank == (nranks - 1))
    {
        // the last rank is the "lucky one", getting more to do
        mystart = myrank * mychunksize;
        mychunksize = mychunksize + leftover;
        mystop = mystart + mychunksize;
    }
    else
    {
        mystart = myrank * mychunksize;
        mystop = mystart + mychunksize;
    }
    // Now that each PE knows where to start and stop, they do the loop
    for (i = mystart; i < mystop; i++)
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
        for (j = 0; j < nb; j++)
        {
            // The manager PE gets the value of the current parameters
            if (myrank == 0)
            {
                as = a[i];
                bs = b[j];
            }
            // and broadcasts it to all others
            mpierr = MPI_Bcast(&as, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);
            mpierr = MPI_Bcast(&bs, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

            // Now each PE calculates its RSS
            rss = 0.0;
            for (k = 0; k < mychunksize; k++)
            {
                ys = as * x[k] + bs;
                rss = rss + pow((ys - y[k]), 2.0);
            }

            // We combine these RSSs with a reduction by sum and send it to the manager
            mpierr = MPI_Reduce(&rss, &worldrss, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
            // The manager stores the MSE from it...
            if (myrank == 0)
            {
                mse.push_back(worldrss / n);
                cout << "(a,b) = (" << a[i] << "," << b[j] << ")      MSE = " << worldrss / n << endl;
            }
        }
    }

    // 4. Look for best combination of (a,b)
    // We will leave that to the manager...
    if (myrank == 0)
    {
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
    }

    // clean up and good bye
    mpierr = MPI_Finalize();
    return 0;
}
