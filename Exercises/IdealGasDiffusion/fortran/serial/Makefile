# Fortran Compiler (GNU here)
FC=gfortran-11

# Compilation flags
FFLAGS=

idealgas_serial.exe: idealgas_serial.o
	$(FC) -o $@ $^

idealgas_serial.o: idealgas_serial.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe