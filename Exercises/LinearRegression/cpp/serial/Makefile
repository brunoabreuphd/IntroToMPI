# C++ Compiler (Intel)
CC=icc

# Compilation flags
CFLAGS=-std=c++14

linreg_serial.exe: linreg_serial.o
	$(CC) -o $@ $^

linreg_serial.o: linreg_serial.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe
