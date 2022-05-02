# MPI Fortran Compiler 
FC=mpifort

# Compilation flags
FFLAGS=

hello_yourwork.exe: hello_yourwork.o
	$(FC) -o $@ $^

hello_yourwork.o: hello_yourwork.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe