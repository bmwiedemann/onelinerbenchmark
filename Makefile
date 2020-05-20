CFLAGS=-O1
BINARIES = benchmark empty empty-static
all: $(BINARIES)

%-static: %.c
	$(CC) $(CFLAGS) -static $< -o $@

example-output.txt: benchmark empty
	taskset 1 ./test.sh | tee $@

clean:
	rm -f $(BINARIES)
