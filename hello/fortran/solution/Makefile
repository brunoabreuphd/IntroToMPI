# MPI Fortran Compiler
FC=mpifort

# Compilation flags
FFLAGS=

hello_mpi.exe: hello_mpi.o
	$(FC) -o $@ $^

hello_mpi.o: hello_mpi.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe