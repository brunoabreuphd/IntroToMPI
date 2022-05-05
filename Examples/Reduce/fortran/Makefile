# MPI Fortran Compiler
FC=mpifort

# Compilation flags
FFLAGS=

reduce_mpi.exe: reduce_mpi.o
	$(FC) -o $@ $^

reduce_mpi.o: reduce_mpi.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe