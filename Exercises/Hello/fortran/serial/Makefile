# Fortran Compiler (Intel)
FC=ifort

# Compilation flags
FFLAGS=

hello_serial.exe: hello_serial.o
	$(FC) -o $@ $^

hello_serial.o: hello_serial.f90
	$(FC) ${FFLAGS} -c $<

clean:
	rm -r *.o *.exe
