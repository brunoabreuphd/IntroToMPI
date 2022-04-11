# C++ Compiler (GNU here)
CC=g++

# Compilation flags
CFLAGS=

hello_yourwork.exe: hello_yourwork.o
	$(CC) -o $@ $^

hello_yourwork.o: hello_yourwork.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe