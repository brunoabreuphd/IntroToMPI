/***
 * File: hello_pseudo_mpi1.cpp
 * Description: Pseudo code with hints to MPI Hello World
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Wednesday, 9th March 2022, 11:34:11 am
 * Last Modified: Wednesday, 9th March 2022, 11:34:14 am
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
// !! HINT1 Include the MPI library here !!

using namespace std;

int main()
{
    int my_rank;
    // !! HINT1 Add a variable to store return values of MPI calls !!

    // !! HINT1 Start MPI by calling MPI_Init !!

    // get my rank
    // !! HINT1 Use MPI_Comm_rank to get each PE's rank !!
    my_rank = 0;

    // print message
    cout << "Hello from PE " << my_rank << endl;

    // !! HINT1 Terminate MPI using MPI_Finalize !!

    // goodbye
    return 0;
}
