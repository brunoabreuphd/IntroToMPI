# MPI Fortran Compiler
FC=mpifort

# Compilation flags
FFLAGS=

snd_rcv_mpi.exe: snd_rcv_mpi.o
	$(FC) -o $@ $^

snd_rcv_mpi.o: snd_rcv_mpi.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe