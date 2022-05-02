# C++ Compiler (GNU here)
CC=g++

# Compilation flags
CFLAGS=

linreg_serial.exe: linreg_serial.o
	$(CC) -o $@ $^

linreg_serial.o: linreg_serial.cpp
	$(CC) ${CFLAGS} -c $<

clean:
	rm -r *.o *.exe