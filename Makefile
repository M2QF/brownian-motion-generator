CC=nvcc

ifeq ($(RELEASE), true)
	CFLAGS=-O3 -Xcompiler -s -Xcompiler -Wall -Xcompiler -Wextra
else
	CFLAGS=-g -Xcompiler -Wall -Xcompiler -Wextra
endif

ifeq ($(OMP), true)
	CFLAGS=$(CFLAGS) -Xcompiler -fopenmp -D_OPENMP
endif

lib/bmg.so: src/bmg.cu header/bmg.h
	$(CC) -o $@ $< -shared -Xcompiler -fPIC -O3 -lcublas -lcusparse -lcurand $(CFLAGS)

clean :
	rm -f lib/bmg.so

release:
	make clean
	make RELEASE=true