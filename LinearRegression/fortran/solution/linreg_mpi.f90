!!!!
!! File: linreg_mpi.f90
!! Description: MPI-parallelized Linear Regression using grid search
!! Author: Bruno R. de Abreu  |  babreu at illinois dot edu
!! National Center for Supercomputing Applications (NCSA)
!!  
!! Creation Date: Monday, 11th April 2022, 1:52:25 pm
!! Last Modified: Monday, 11th April 2022, 3:21:45 pm
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

program linreg_mpi
    use mpi
    implicit none
    ! parameter map variables
    integer, parameter :: na=10, nb=10  ! number of points for each parameter in grid space
    double precision, parameter :: da=0.1d0, db=0.1d0   ! grid spacing in each direction
    double precision, dimension(:), allocatable :: a, b ! parameters in each direction

    ! target straight line variables
    integer, parameter :: n = 2**27   ! number of data points
    double precision, dimension(:), allocatable :: x    ! control variable
    double precision :: dx  ! control variable spacing
    double precision, dimension(:), allocatable :: y    ! response variable
    double precision, parameter :: at=0.5d0, bt=0.5d0   ! target paramters

    ! metrics variables
    double precision :: rss    ! residual sum of squares
    double precision, dimension(:), allocatable :: mse  ! mean squared error
    double precision :: best_mse    ! best MSE

    ! random number variables
    integer, dimension(:), allocatable :: seed
    integer :: seed_size
    double precision :: rand1, rand2    ! hold random numbers
    double precision :: z               ! Box-Muller transform
    double precision, parameter :: pi = 4.d0*atan(1.d0) ! Pi = 3.14159...

    ! integer helpers
    integer :: i, j, k  ! loopers
    integer :: counter
    integer :: best_i, best_j
    ! double helpers
    double precision :: as, bs  ! search parameters
    double precision :: ys  ! estimate of y using as,bs
    double precision :: xp, yp  ! temporaty variables (p from prime)

    ! MPI variables
    integer :: myrank   ! PE ID
    integer :: nranks   ! total number of PEs
    integer :: mpierr   ! return from MPI routines

    ! Distributed task variables
    integer :: mychunksize ! number of loop iterations for each PE
    integer :: leftover     ! in case n is not divisble by number of PEs
    integer :: mystart, mystop  ! each PE start and stop iteration values
    double precision :: worldrss    ! the reduction-combined RSS

    ! Start MPI
    call MPI_INIT(mpierr)
    ! Get the number of PEs
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nranks, mpierr)
    ! Get each PE's ID
    call MPI_COMM_RANK(MPI_COMM_WORLD, myrank, mpierr)

    ! 1. Build parameter map
    ! We only want PE 0 to do this, no need for the others to know about it
    if (myrank == 0) then
        allocate(a(na))
        allocate(b(nb))
        allocate(mse(na*nb))
        do i = 1, na
            a(i) = i*da
        enddo
        do j = 1, nb
            b(j) = j*db
        enddo
    endif 

    ! 2. Build the dataset
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    seed = myrank   ! We use a different seed for each PE
    call random_seed(put=seed) ! start random number generator
    dx = 1.d0 / dble(n) ! we will make x go from 0 to 1
    ! Now we need to carefully distribute the correct loop interval to each PE
    ! First, find the chunk size
    mychunksize = n / nranks
    leftover = mod(n, nranks)
    if (myrank == (nranks-1)) then
        ! the last rank is the "lucky duck", gets more to do
        mystart = myrank * mychunksize
        mychunksize = mychunksize + leftover
        mystop = mystart + mychunksize
    else
        ! the other PEs are okay
        mystart = myrank * mychunksize
        mystop = mystart + mychunksize
    endif
    ! Allocate the memory space for each PE
    allocate(x(mystart:mystop))
    allocate(y(mystart:mystop))
    ! Now each PE knows where to start and stop, so let's do the loop
    do i = mystart, mystop
        xp = i * dx
        yp = at*xp + bt     ! target y=at*x + bt
        call random_number(rand1)   ! uniform RN 1
        call random_number(rand2)   ! uniform RN 2
        z = sqrt(-2.d0*log(rand1)) * cos(2.d0*pi*rand2) ! Box-Muller transformation
        yp = yp + z ! add Gaussian noise
        x(i) = xp
        y(i) = yp
    enddo

    ! 3. Explore parameter space
    counter = 1
    worldrss = 0.d0
    do i = 1, na
        do j = 1, nb
            ! The manager PE gets the value of the current parameters
            if (myrank == 0) then
                as = a(i)
                bs = b(j)
            endif
            ! And broadcasts it to all others
            call MPI_BCAST(as, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD, mpierr)
            call MPI_BCAST(bs, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD, mpierr)

            ! Now each PE calculates its own RSS
            rss = 0.d0
            do k = mystart, mystop
                ys = as*x(k) + bs
                rss = rss + (ys - y(k))**2.d0
            enddo

            ! Combine these RSSs with a reduction by sum and send it to the manager PE
            call MPI_REDUCE(rss, worldrss, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD, mpierr)
            ! Manager then stores it...
            if (myrank == 0) then
                mse(counter) = worldrss / dble(n)
                write(*,*) "(a,b) = (", as, ",", bs, ")    RSS = ", worldrss/dble(n)
            endif
            counter = counter + 1
        enddo
    enddo

    ! 4. Look for best combination of (a,b)
    ! We leave this task to the manager
    if (myrank == 0) then
        counter = 1
        best_mse = mse(1)
        best_i = 1
        best_j = 1
        do i = 1, na
            do j = 1, nb
                if(mse(counter) < best_mse) then
                    best_mse = mse(counter)
                    best_i = i
                    best_j = j
                endif
                counter = counter + 1
            enddo
        enddo
        write(*,*) 
        write(*,*)
        write(*,*) "Best fit is for (a,b) = (", a(best_i), ",", b(best_j), ")"
        write(*,*) "with MSE = ", best_mse

        ! clean up
        deallocate(a,b,mse)
    endif

    ! clean up and goodbye
    deallocate(x, y, seed)
    call MPI_FINALIZE(mpierr)

end program linreg_mpi
