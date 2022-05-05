/***
 * File: bcast_mpi.cpp
 * Description: Coin Toss experiment using MPI_BCAST
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Tuesday, 3rd May 2022, 2:25:16 pm
 * Last Modified: Tuesday, 3rd May 2022, 2:25:19 pm
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
    int my_id;                                 // ID of each PE
    int mpierr;                                // MPI return codes
    char coinState;                            // the state of the coin: H or T
    double rn;                                 // random number
    mt19937 gen;                               // Mersenne-Twister randon number generator
    uniform_real_distribution<> urd(0.0, 1.0); // uniform distrbution over (0,1)

    // 3. Start the MPI environments
    mpierr = MPI_Init(NULL, NULL);

    // 4. Get the ID of each PE
    mpierr = MPI_Comm_rank(MPI_COMM_WORLD, &my_id);

    // 5. Flip a coin for each process and print it
    gen.seed(my_id); // start the random number generator with a different seed for each PE
    rn = urd(gen);
    if (rn > 0.5)
    {
        coinState = 'H';
    }
    else
    {
        coinState = 'T';
    }
    cout << "I'm PE " << my_id << " and my coin state is: " << coinState << endl;

    // 6. Use MPI_BCAST to reset the states to the one of PE 0
    mpierr = MPI_Bcast(&coinState, 1, MPI_CHAR, 0, MPI_COMM_WORLD);
    if (my_id != 0)
    {
        cout << "I'm PE " << my_id << ". I received a broadcast from PE 0 and now my coin state is: " << coinState << endl;
    }
    // 7. Close MPI environment
    mpierr = MPI_Finalize();

    // goodbye
    return 0;
}