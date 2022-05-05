!!!!
!! File: bcast_mpi.f90
!! Description: Coin Toss experiment using MPI_BCAST
!! Author: Bruno R. de Abreu  |  babreu at illinois dot edu
!! National Center for Supercomputing Applications (NCSA)
!!  
!! Creation Date: Thursday, 5th May 2022, 6:45:41 am
!! Last Modified: Thursday, 5th May 2022, 7:03:34 am
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

program bcast_mpi
    ! 1. Include MPI header
    use mpi
    implicit none

    ! 2. Declare variables
    integer :: my_id   ! ID of each PE
    integer :: mpierr   ! MPI return codes
    character :: coinState  ! the state of the coin: H or T
    real*8 :: rn    ! random number
    integer :: seed_size
    integer, dimension(:), allocatable :: seed

    ! 3. Start the MPI environment
    call MPI_INIT(mpierr)

    ! 4. Get the ID of each PE
    call MPI_COMM_RANK(MPI_COMM_WORLD, my_id, mpierr)

    ! 5. Flip a coin for each process and print it
    ! Start a the random number generation with a different seed for each PE
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    seed = my_id*1000000
    call random_seed(put=seed)
    call random_number(rn)
    if (rn > 0.5d0) then
        coinState = 'H'
    else
        coinState = 'T'
    endif
    write(*,*) "I'm PE", my_id, "and my coin state is: ", coinState

    ! 6. Use MPI_BCAST to reset the states to that of PE 0
    call MPI_BCAST(coinState, 1, MPI_CHARACTER, 0, MPI_COMM_WORLD, mpierr)
    if (my_id .ne. 0) then
        write(*,*) "I'm PE", my_id, ". I just received a message from PE 0 and now my coin state is: ", coinState
    endif

    ! 7. Cleanup and close MPI
    deallocate(seed)
    call MPI_FINALIZE(mpierr)
end program bcast_mpi