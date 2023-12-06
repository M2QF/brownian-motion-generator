CC=nvcc

ifeq ($(RELEASE), true)
	CFLAGS=-O3 -Xcompiler -s -Xcompiler -Wall -Xcompiler -Wextra
else
	CFLAGS=-g -Xcompiler -Wall -Xcompiler -Wextra
endif

LIBS=-lcublas -lcusparse -lcurand

all : lib/libbmg.a lib/libbmg_omp.a

lib/libbmg.a: obj/bmg.o
	ar rcs $@ $<

lib/libbmg_omp.a: obj/bmg_omp.o
	ar rcs $@ $<

obj/bmg.o: src/bmg.cu header/bmg.h
	$(CC) -c -o $@ $< $(FLAGS) $(LIBS)

obj/bmg_omp.o: src/bmg.cu header/bmg.h
	@echo "Compiling with OpenMP"
	$(CC) -c -o $@ $< $(FLAGS) $(LIBS) -Xcompiler -fopenmp

clean :
	rm -f -v lib/bmg.a
	rm -f -v obj/*.o

release:
	make clean
	make RELEASE=true