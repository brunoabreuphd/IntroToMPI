# C++ Compiler (GNU here)
CC=g++

# Compilation flags
CFLAGS=

linreg_yourwork.exe: linreg_yourwork.o
	$(CC) -o $@ $^

linreg_yourwork.o: linreg_yourwork.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe