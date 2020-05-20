CFLAGS=-O1
all: benchmark empty

example-output.txt: benchmark
	taskset 1 ./test.sh > $@

clean:
	rm -f benchmark empty
