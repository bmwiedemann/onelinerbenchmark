CFLAGS=-O1
all: benchmark empty

example-output.txt: benchmark empty
	taskset 1 ./test.sh | tee $@

clean:
	rm -f benchmark empty
