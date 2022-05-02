/***
 * File: snd_rcv_mpi.cpp
 * Description: A typical MPI Blocking P2P communication
 * Author: Bruno R. de Abreu  |  babreu at illinois dot edu
 * National Center for Supercomputing Applications (NCSA)
 *
 * Creation Date: Monday, 2nd May 2022, 2:26:26 pm
 * Last Modified: Monday, 2nd May 2022, 2:26:28 pm
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
#include <iostream>
#include <mpi.h>

using namespace std;

int main()
{
    // 2. Declare variables
    int my_id;         // id of each PE
    int mpierr;        // MPI return codes
    MPI_Status status; // status about received messages
    double A;          // variable whose content is going to be sent

    // 3. Start MPI environment
    mpierr = MPI_Init(NULL, NULL);

    // 4. Get the ID of each PE
    mpierr = MPI_Comm_rank(MPI_COMM_WORLD, &my_id);

    // 5. Perform P2P communication
    // set value of A in PE 0, send it to PE 1
    if (my_id == 0)
    {
        A = 42.0;
        cout << "I'm PE " << my_id << " and my value for A is " << A << " . I will send this to PE 1 now." << endl;
        mpierr = MPI_Send(&A, 1, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD);
    }
    else if (my_id == 1)
    {
        A = 13.0;
        cout << "I'm PE " << my_id << " and the value that I have for A is " << A << endl;
        mpierr = MPI_Recv(&A, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
        cout << "This is PE " << my_id << " again. I just received a message from PE 0. The value that I have for A now is " << A << endl;
    }

    // 6. Close MPI communications
    mpierr = MPI_Finalize();

    // goodbye
    return 0;
}
