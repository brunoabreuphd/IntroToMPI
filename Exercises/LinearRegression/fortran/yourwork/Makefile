# Fortran MPI Compiler 
FC=mpifort

# Compilation flags
FFLAGS=

linreg_yourwork.exe: linreg_yourwork.o
	$(FC) -o $@ $^

linreg_yourwork.o: linreg_yourwork.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe