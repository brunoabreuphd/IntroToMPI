!!!!
!! File: reduce_mpi.f90
!! Description: Coin-toss experiment with MPI_REDUCE
!! Author: Bruno R. de Abreu  |  babreu at illinois dot edu
!! National Center for Supercomputing Applications (NCSA)
!!  
!! Creation Date: Thursday, 5th May 2022, 7:15:50 am
!! Last Modified: Thursday, 5th May 2022, 7:37:21 am
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

program reduce_mpi
    ! 1. Include MPI header
    use mpi
    implicit none

    ! 2. Declare variables
    integer, parameter :: nFlips = 1000 ! Number of coin flips for each PE
    integer :: myID         ! ID of each PE
    integer :: nPEs         ! number of PEs
    integer :: mpierr       ! MPI return codes
    integer :: myHeads      ! number of heads for each PE
    integer :: nHeads       ! total number of heads
    integer :: seed_size    ! random number generator seed size
    integer, dimension(:), allocatable :: seed  ! the seed
    integer :: i            ! loop helper
    real*8 :: rn            ! random number

    ! 3. Start the MPI environment
    call MPI_INIT(mpierr)

    ! 4. Get the ID of each PE
    call MPI_COMM_RANK(MPI_COMM_WORLD, myID, mpierr)

    ! 5. Get the total number of PEs
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nPEs, mpierr)

    ! 6. Start the experiment: each PE flips the coin several times
    nHeads = 0
    myHeads = 0
    ! start the random number generator with a different seed for each PE
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    seed = myID * 1000000
    call random_seed(put=seed)
    do i = 1, nFlips
        call random_number(rn)
        if (rn > 0.5) then
            myHeads = myHeads + 1
        endif
    enddo
    ! print the results for each PE
    write(*,*) "I'm PE", myID, "and I got heads", myHeads, "times (", 100*dble(myHeads)/dble(nFlips), "%)"

    ! 7. Combine results and send it to PE 0
    call MPI_REDUCE(myHeads, nHeads, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD, mpierr)
    ! print result
    if (myID .eq. 0) then
        write(*,*) "The total number of heads was ", nHeads, "(", 100*dble(nHeads) / (dble(nFlips*nPEs)), "%)"
    endif

    ! 8. Cleanup and close MPI
    deallocate(seed)
    call MPI_FINALIZE(mpierr)
end program reduce_mpi
