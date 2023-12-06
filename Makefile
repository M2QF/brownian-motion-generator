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
	DEL=del /Q
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
	DEL=rm -f -v
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

obj/bmg.o: src/bmg.cu header/bmg.h
	$(CC) -c -o $@ $< $(FLAGS) $(LIBS)

clean :
	$(DEL) lib/bmg.a
	$(DEL) lib/bmg.lib
	$(DEL) obj/*.o*

linux_release:
	make clean
	make linux RELEASE=true

windows_release:
	make clean
	make windows RELEASE=true

omp:
	make clean
	make linux OMP=true

omp_release:
	make clean
	make linux OMP=true RELEASE=true