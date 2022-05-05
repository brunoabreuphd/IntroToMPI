!!!!
!! File: idealgas_serial.f90
!! Description: 1-D Ideal gas diffusion, serial code
!! Author: Bruno R. de Abreu  |  babreu at illinois dot edu
!! National Center for Supercomputing Applications (NCSA)
!!  
!! Creation Date: Thursday, 5th May 2022, 9:35:48 am
!! Last Modified: Thursday, 5th May 2022, 10:40:13 am
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

module countParticles
    implicit none

    contains
    
    subroutine calculatePartitionFilling(positions, pttS, pttE, nPartPart)
        implicit none
        real*8, intent(in) :: positions(:)
        real*8, intent(in) :: pttS(:)
        real*8, intent(in) :: pttE(:)
        integer, intent(inout) :: nPartPart(:)

        integer :: nParticles
        integer :: nPartitions
        integer :: i, j

        nParticles = size(positions)
        nPartitions = size(pttS)

        nPartPart = 0
        do i = 1, nPartitions
            do j = 1, nParticles
                if(positions(j) .ge. pttS(i) .and. positions(j) .lt. pttE(i)) then
                    nPartPart(i) = nPartPart(i) + 1
                endif
            enddo
        enddo

    end subroutine calculatePartitionFilling
end module countParticles

program idealgas_serial
    use countParticles
    implicit none
    ! parameters, these won't change
    integer, parameter :: nParticles = 100  ! number of particles in the system
    real*8, parameter :: boxSize = 1.0      ! size of the 1D box
    real*8, parameter :: partDens = dble(nParticles) / boxSize  ! number density
    integer, parameter :: nPartitions = 10  ! number of partitions in the box
    integer, parameter :: nSteps = 10**6     ! number of trial moves
    integer, parameter :: nChecks = 5       ! number of checkpoints

    ! variables
    real*8, dimension(:), allocatable :: positions  ! position of the particles
    integer, dimension(:), allocatable :: nPartPart ! number of particles in each partition
    real*8, dimension(:), allocatable :: pttS       ! partitions start
    real*8, dimension(:), allocatable :: pttE       ! partitions end

    ! random number helpers
    real*8 :: drn    ! double-precision random number
    integer :: irn  ! integer random number
    integer :: seed_size    ! rn generator seed size
    integer, dimension(:), allocatable :: seed  ! the seed

    ! other helpers
    integer :: i, j        ! loops
    real*8 :: trDisp    ! trial displacement
    real*8 :: newPos    ! new position after displacement
    real*8 :: dx        ! partition size

    ! allocate
    allocate(positions(nParticles))
    allocate(nPartPart(nPartitions))
    allocate(pttS(nPartitions))
    allocate(pttE(nPartitions))

    ! define partitions
    dx = boxSize / dble(nPartitions)
    do i = 1, nPartitions
        pttS(i) = (i-1)*dx
        pttE(i) = pttS(i) + dx
    enddo

    ! 1. Start random number generator
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    seed = 0
    call random_seed(put=seed)

    ! 2. Distribute particles in initial configuration: all particles in the first partition
    do i = 1, nParticles
        call random_number(drn)      ! between (0,1)
        positions(i) = drn*dx   ! inside first partition
    enddo

    ! 3. Start diffusion process
    do i = 1, nSteps
        ! select a random particle
        call random_number(drn)
        irn = int(drn*nParticles) + 1
        ! propose a random displacement
        call random_number(drn)
        trDisp = (2.0*drn - 1.0)*boxSize
        newPos = positions(irn) + trDisp
        ! check if it is inbounds
        if (newPos .gt. 0.d0 .and. newPos .lt. boxSize) then
            positions(irn) = newPos
        endif
        ! check point?
        if (mod(i, nSteps/nChecks) .eq. 0) then
            call calculatePartitionFilling(positions, pttS, pttE, nPartPart)
            write(*,*) "Number of steps: ", i
            do j = 1, nPartitions
                write(*,*) "Partition: ", j, "Particles: ", nPartPart(j)
            enddo
            write(*,*)
        endif
    enddo

    ! Cleanup and goodbye
    deallocate(positions)
    deallocate(nPartPart)
    deallocate(pttS, pttE)
    deallocate(seed)
    
end program idealgas_serial
