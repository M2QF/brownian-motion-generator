CC=nvcc

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

lib/bmg.so: src/bmg.cu header/bmg.h
	$(CC) -o $@ $< -shared -Xcompiler -fPIC -O3 -lcublas -lcusparse -lcurand $(FLAGS)

clean :
	rm -f lib/bmg.so

release:
	make clean
	make RELEASE=true

omp:
	make clean
	make OMP=true

omp_release:
	make clean
	make OMP=true RELEASE=true