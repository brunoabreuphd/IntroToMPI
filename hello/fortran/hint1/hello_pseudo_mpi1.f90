!!!!
!! File: hello_pseudo_mpi1.f90
!! Description: Pseudo code with hints to MPI Hello World
!! Author: Bruno R. de Abreu  |  babreu at illinois dot edu
!! National Center for Supercomputing Applications (NCSA)
!!  
!! Creation Date: Monday, 11th April 2022, 10:37:39 am
!! Last Modified: Monday, 11th April 2022, 10:42:14 am
!!  
!! Copyright (c) 2022, Bruno R. de Abreu, National Center for Supercomputing Applications.
!! All rights reserved.
!! License: This program and the accompanying materials are made available to any individual
!!          under the citation condition that follows: On the event that the software is
!!          used to generate data that is used implicitly or explicitly for research
!!          purposes, proper acknowledgment must be provided in the citations section of
!!          publications. This includes both the author's name and the National Center
!!          for Supercomputing Applications. If you are uncertain about how to do
!!          so, please check this page: https://github.com/babreu-ncsa/cite-me.
!!          This software cannot be used for commercial purposes in any way whatsoever.
!!          Omitting this license when redistributing the code is strongly disencouraged.
!!          The software is provided without warranty of any kind. In no event shall the
!!          author or copyright holders be liable for any kind of claim in connection to
!!          the software and its usage.
!!!!

program hello_pseudo_mpi1
    ! ## HINT1 Include the MPI module here ##
    implicit none
    integer :: my_rank
    ! ## HINT1 Add a variable to keep track of MPI return errors ##

    ! ## HINT1 Start the MPI environment with MPI_INIT ##
    
    ! get my rank 
    ! ## HINT1 Use MPI_COMM_RANK to get each PEs rank ##
    my_rank = 0

    ! print message
    write(*,*) "Hello from PE", my_rank

    ! ## HINT1 Close the MPI environment with MPI_FINALIZE ##

end program hello_pseudo_mpi1
