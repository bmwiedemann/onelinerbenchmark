CFLAGS=-O1
BINARIES = benchmark benchmarkfork empty emptyssl empty-static empty-static-uclibc emptyrs emptygo
all: $(BINARIES)

emptyssl: empty.c
	$(CC) $(CFLAGS) -lssl $< -o $@
	strip $@

%-static: %.c
	$(CC) $(CFLAGS) -static $< -o $@
	strip $@

%-static-uclibc: %.c
	gcc-uClibc $(CFLAGS) -static $< -o $@
	strip $@

%: %.rs
	rustc $<
	strip $@

%: %.go
	go build $<
	strip $@

example-output.txt: $(BINARIES)
	taskset 1 ./test.sh | tee $@

clean:
	rm -f $(BINARIES)
