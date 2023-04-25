# MPI C++ Compiler (Intel)
CC=mpiicc

# Compilation flags
CFLAGS=-std=c++14

linreg_yourwork.exe: linreg_yourwork.o
	$(CC) -o $@ $^

linreg_yourwork.o: linreg_yourwork.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe
