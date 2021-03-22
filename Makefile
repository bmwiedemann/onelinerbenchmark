CFLAGS=-O1
BINARIES = benchmark empty empty-static empty-static-uclibc emptyrs
all: $(BINARIES)

%-static: %.c
	$(CC) $(CFLAGS) -static $< -o $@
	strip $@

%-static-uclibc: %.c
	gcc-uClibc $(CFLAGS) -static $< -o $@
	strip $@

%: %.rs
	rustc $<
	strip $@

example-output.txt: benchmark empty
	taskset 1 ./test.sh | tee $@

clean:
	rm -f $(BINARIES)
