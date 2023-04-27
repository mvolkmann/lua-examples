CC=gcc 
CFLAGS=-llua

#objects = helpers.o main.o

# This is the default target because it is
# the first one that does not begin with a period.
all: main run

main: main.c helpers.c
	$(CC) $^ $(CFLAGS) -o $@

run: main
	./main

clean:
	rm -f main *.o

