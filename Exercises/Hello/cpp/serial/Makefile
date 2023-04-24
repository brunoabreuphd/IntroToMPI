# C++ Compiler (Intel)
CC=icc

# Compilation flags
CFLAGS=

hello_serial.exe: hello_serial.o
	$(CC) -o $@ $^

hello_serial.o: hello_serial.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe
