CC=gcc 
LDFLAGS=-llua
EXE=main
objects=helpers.o main.o

run: $(EXE)
	@ ./$(EXE) 

main: $(objects)
	@ $(CC) -o $@ $(LDFLAGS) $^

clean:
	@ rm -f *.o $(EXE)

# This causes .c files to be recompiled
# when the corresponding .h file is modified.
%.c: %.h
	@ touch $@

