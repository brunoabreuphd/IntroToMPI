# MPI C++ Compiler
CC=mpic++

# Compilation flags
CFLAGS=

bcast_mpi.exe: bcast_mpi.o
	$(CC) -o $@ $^

bcast_mpi.o: bcast_mpi.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe