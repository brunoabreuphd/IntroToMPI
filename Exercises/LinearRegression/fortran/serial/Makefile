# Fortran Compiler (Intel)
FC=ifort

# Compilation flags
FFLAGS=

linreg_serial.exe: linreg_serial.o
	$(FC) -o $@ $^

linreg_serial.o: linreg_serial.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe
