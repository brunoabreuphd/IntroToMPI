/***
 * File: reduce_mpi.cpp
 * Description: Coin-toss experiment with MPI_REDUCE
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Thursday, 5th May 2022, 7:43:31 am
 * Last Modified: Thursday, 5th May 2022, 7:43:34 am
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

// 1. Include MPI header
#include <mpi.h>    // MPI
#include <iostream> // input/output
#include <random>   // random number generator

using namespace std;

int main()
{
    // 2. Declare variables
    int nFlips = 1000;                         // number of coin flips for each PE
    int myID;                                  // ID of each PE
    int nPEs;                                  // number of PEs
    int mpierr;                                // MPI return codes
    int myHeads;                               // number of heads for each PE
    int nHeads;                                // total number of heads
    int i;                                     // loop helper
    double rn;                                 // random number
    mt19937 gen;                               // Mersenne-Twister random number generator
    uniform_real_distribution<> urd(0.0, 1.0); // uniform distribution over (0,1)

    // 3. Start the MPI environment
    mpierr = MPI_Init(NULL, NULL);

    // 4. Get the ID of each PE
    mpierr = MPI_Comm_rank(MPI_COMM_WORLD, &myID);

    // 5. Get the tital number of PEs
    mpierr = MPI_Comm_size(MPI_COMM_WORLD, &nPEs);

    // 6. Start the experiment: each PE flips the coin several times
    myHeads = 0;
    nHeads = 0;
    // start the random number generator with a different seed for each PE
    gen.seed(myID * 100000);
    for (i = 0; i < nFlips; i++)
    {
        rn = urd(gen);
        if (rn > 0.5)
        {
            myHeads = myHeads + 1;
        }
    }
    // print the results for each PE
    cout << "I'm PE " << myID << " and I got heads " << myHeads << " times (" << 100.0 * myHeads / nFlips << "%)" << endl;

    // 7. Combine results and send it to PE 0
    mpierr = MPI_Reduce(&myHeads, &nHeads, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    // print result
    if (myID == 0)
    {
        cout << "The total number of heads was " << nHeads << " (" << 100.0 * nHeads / (nFlips * nPEs) << "%)" << endl;
    }

    // 8. Cleanup and close MPI
    mpierr = MPI_Finalize();

    return 0;
}
