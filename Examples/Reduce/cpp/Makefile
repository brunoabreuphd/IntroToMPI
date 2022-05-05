# MPI C++ Compiler
CC=mpic++

# Compilation flags
CFLAGS=

reduce_mpi.exe: reduce_mpi.o
	$(CC) -o $@ $^

reduce_mpi.o: reduce_mpi.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe