# C++ Compiler (GNU here)
CC=g++

# Compilation flags
CFLAGS=

hello_serial.exe: hello_serial.o
	$(CC) -o $@ $^

hello_serial.o: hello_serial.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe