/***
 * File: hello_mpi.cpp
 * Description: MPI Hello World
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Wednesday, 9th March 2022, 10:33:04 am
 * Last Modified: Wednesday, 9th March 2022, 10:33:11 am
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

/****
 ***    This is a solution to the Hello World exercise.
 ***    I recommend you do not read this file any further
 ***    unless you are sure you checked all the hints and
 ***    tried your best to code it yourself.
 ****/

#include <iostream>
#include <mpi.h>

using namespace std;

int main()
{
    int my_rank;
    int mpierr; // this will hold error codes for MPI calls

    // start MPI
    mpierr = MPI_Init(NULL, NULL);

    // get my rank
    mpierr = MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    // print message
    cout << "Hello from PE " << my_rank << endl;

    // terminate MPI
    mpierr = MPI_Finalize();

    // goodbye
    return 0;
}
