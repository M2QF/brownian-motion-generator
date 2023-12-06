CC=nvcc

ifeq ($(RELEASE), true)
	CFLAGS=-O3 -Xcompiler -s -Xcompiler -Wall -Xcompiler -Wextra
else
	CFLAGS=-g -Xcompiler -Wall -Xcompiler -Wextra
endif

bmg.so: bmg.cu
	$(CC) -o bmg.so bmg.cu -shared -Xcompiler -fPIC -O3 -lcublas -lcusparse -lcurand $(CFLAGS)

clean :
	rm -f bmg.so

release:
	make clean
	make RELEASE=true