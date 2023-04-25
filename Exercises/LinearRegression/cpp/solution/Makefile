# MPI C++ Compiler (Intel)
CC=mpiicc

# Compilation flags
CFLAGS=-std=c++14

linreg_mpi.exe: linreg_mpi.o
	$(CC) -o $@ $^

linreg_mpi.o: linreg_mpi.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe
