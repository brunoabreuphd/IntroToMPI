!!!!
!! File: snd_rcv_mpi.f90
!! Description: A typical MPI Blocking P2P communication
!! Author: Bruno R. de Abreu  |  babreu at illinois dot edu
!! National Center for Supercomputing Applications (NCSA)
!!  
!! Creation Date: Monday, 2nd May 2022, 2:59:56 pm
!! Last Modified: Monday, 2nd May 2022, 3:11:30 pm
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

program snd_rcv_mpi
    ! 1. Include MPI header 
    use mpi
    implicit none

    ! 2. Declare variables
    integer :: my_id    ! holds the ID of each PE
    integer :: mpierr   ! return code of MPI lib calls
    integer :: status(MPI_STATUS_SIZE)  ! holds status about received messages
    real*8 :: A         ! variable whose content is going to be sent

    ! 3. Start MPI environment
    call MPI_INIT(mpierr)

    ! 4. Get the ID of each PE
    call MPI_COMM_RANK(MPI_COMM_WORLD, my_id, mpierr)

    ! 5. Perform P2P communication
    ! set value of A in PE 0, then send to PE 1
    if (my_id .eq. 0) then
        A = 42.d0
        write(*,*) "I'm PE", my_id, "and my value for A is" , A, ". I will send this to PE 1 now."
        call MPI_SEND(A, 1, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, mpierr)
    else if (my_id .eq. 1) then
        A = 13.0
        write(*,*) "I'm PE", my_id, "and the value that I have for A is", A
        call MPI_RECV(A, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, status, mpierr)
        write(*,*) "This is PE", my_id, "again. I just received a message from PE 0. The value that I have for A now is", A
    endif

    ! 6. Close MPI communications
    call MPI_FINALIZE(mpierr)

end program snd_rcv_mpi
