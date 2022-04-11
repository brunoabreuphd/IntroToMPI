program hello_yourwork
    implicit none
    integer :: my_rank

    ! get my rank -- serial code has just one process
    my_rank = 0

    ! print message
    write(*,*) "Hello from PE", my_rank

end program hello_yourwork