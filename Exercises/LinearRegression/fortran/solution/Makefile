# MPI Fortran Compiler
FC=mpifort

# Compilation flags
FFLAGS=

linreg_mpi.exe: linreg_mpi.o
	$(FC) -o $@ $^

linreg_mpi.o: linreg_mpi.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe