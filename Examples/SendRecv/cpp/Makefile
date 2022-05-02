
# MPI C++ Compiler
CC=mpic++

# Compilation flags
CFLAGS=

snd_rcv_mpi.exe: snd_rcv_mpi.o
	$(CC) -o $@ $^

snd_rcv_mpi.o: snd_rcv_mpi.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe