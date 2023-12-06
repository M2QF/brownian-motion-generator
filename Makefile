CC=nvcc

ifeq ($(OS), Windows_NT)
	ifeq ($(RELEASE), true)
		CFLAGS=-O3
	else
		CFLAGS=-g
	endif

	ifeq ($(OMP), true)
		FLAGS=$(CFLAGS) -Xcompiler /openmp
	else
		FLAGS=$(CFLAGS)
	endif
else
	ifeq ($(RELEASE), true)
		CFLAGS=-O3 -Xcompiler -s -Xcompiler -Wall -Xcompiler -Wextra
	else
		CFLAGS=-g -Xcompiler -Wall -Xcompiler -Wextra
	endif

	ifeq ($(OMP), true)
		FLAGS=$(CFLAGS) -Xcompiler -fopenmp
	else
		FLAGS=$(CFLAGS)
	endif
endif


LIBS=-lcublas -lcusparse -lcurand

all: windows linux

windows: lib/bmg.lib

linux: lib/libbmg.a

lib/bmg.lib: obj/bmg.obj
	lib /OUT:$@ $<

obj/bmg.obj: src/bmg.cu header/bmg.h
	$(CC) -c -o $@ $< $(FLAGS) $(LIBS)

lib/libbmg.a: obj/bmg.o
	ar rcs $@ $<

lib/bmg.o: src/bmg.cu header/bmg.h
	$(CC) -c -o $@ $< $(FLAGS) $(LIBS)

clean :
	rm -f -v lib/bmg.a
	rm -f -v lib/bmg.lib
	rm -f -v obj/*.o*

release:
	make clean
	make RELEASE=true

omp:
	make clean
	make OMP=true

omp_release:
	make clean
	make OMP=true RELEASE=true