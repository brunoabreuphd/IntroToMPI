# MPI C++ Compiler
CC=mpic++

# Compilation flags
CFLAGS=

linreg_mpi.exe: linreg_mpi.o
	$(CC) -o $@ $^

linreg_mpi.o: linreg_mpi.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe