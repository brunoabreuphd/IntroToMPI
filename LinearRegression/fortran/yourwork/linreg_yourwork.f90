program linreg_yourwork
    implicit none
    ! parameter map variables
    integer, parameter :: na=10, nb=10  ! number of points for each parameter in grid space
    double precision, parameter :: da=0.1d0, db=0.1d0   ! grid spacing in each direction
    double precision, dimension(:), allocatable :: a, b ! parameters in each direction

    ! target straight line variables
    integer, parameter :: n = 2**23   ! number of data points
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

    ! allocate arrays
    allocate(a(na))
    allocate(b(nb))
    allocate(x(n))
    allocate(y(n))
    allocate(mse(na*nb))

    ! 1. Build parameter map - square grid in (a,b)-space
    do i = 1, na
        a(i) = i*da
    enddo
    do j = 1, nb
        b(j) = j*db
    enddo

    ! 2. Build the dataset
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    seed = 0
    call random_seed(put=seed) ! start random number generator
    dx = 1.d0 / dble(n) ! we will make x go from 0 to 1
    do i = 1, n
        xp = i*dx
        yp = at*xp + bt ! target y = at*x + bt
        call random_number(rand1)   ! uniform RN 1
        call random_number(rand2)   ! uniform RN 2
        z = sqrt(-2.d0*log(rand1)) * cos(2.d0*pi*rand2) ! Box-Muller transformation
        yp = yp + z ! add Gaussian noise
        x(i) = xp
        y(i) = yp
    enddo

    ! 3. Explore parameter space
    counter = 1
    do i = 1, na
        as = a(i)
        do j = 1, nb
            bs = b(j)
            rss = 0.d0
            do k = 1, n
                ys = as*x(k) + bs
                rss = rss + (ys - y(k))**2.d0
            enddo
            mse(counter) = rss / dble(n)
            counter = counter + 1
            write(*,*) "(a,b) = (", as, ",", bs, ")    RSS = ", rss/dble(n)
        enddo
    enddo

    ! 4. Look for best combination of (a,b)
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
    deallocate(a, b, x, y, mse, seed)

end program linreg_yourwork