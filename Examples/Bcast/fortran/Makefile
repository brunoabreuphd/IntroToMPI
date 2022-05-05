# MPI Fortran Compiler
FC=mpifort

# Compilation flags
FFLAGS=

bcast_mpi.exe: bcast_mpi.o
	$(FC) -o $@ $^

bcast_mpi.o: bcast_mpi.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe