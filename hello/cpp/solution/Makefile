# MPI C++ Compiler
CC=mpic++

# Compilation flags
CFLAGS=

hello_mpi.exe: hello_mpi.o
	$(CC) -o $@ $^

hello_mpi.o: hello_mpi.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe