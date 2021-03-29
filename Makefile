CFLAGS=-O1
BINARIES = benchmark benchmarkfork empty emptyssl emptycurl empty-static empty-static-uclibc emptyrs emptygo
all: $(BINARIES)

emptyssl: empty.c
	$(CC) $(CFLAGS) -lssl $< -o $@
	strip $@

emptycurl: empty.c
	$(CC) $(CFLAGS) -lssl -lcurl $< -o $@
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

example-output-nocache.txt: $(BINARIES)
        DROPCACHES=1 taskset 1 ./test.sh | tee $@

clean:
	rm -f $(BINARIES)
