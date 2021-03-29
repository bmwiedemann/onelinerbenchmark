// gcc -O1 -o benchreg benchreg.c

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

static __inline__ unsigned long long rdtsc(void)
{
    unsigned hi, lo;
    __asm__ __volatile__ ("rdtscp" : "=a"(lo), "=d"(hi) :: "rcx");
    return ( (unsigned long long)lo)|( ((unsigned long long)hi)<<32 );
}

static inline long long timediff(const struct timeval *tv1, const struct timeval *tv2)
{
  return 1000000LL*(tv2->tv_sec-tv1->tv_sec) + tv2->tv_usec - tv1->tv_usec;
}

int main(int argc, char **argv)
{
  int i;
  unsigned long long start, end;
  struct timeval tv1, tv2;
  if(argc<2)
    exit(55);
  if(argc>2)
    sscanf(argv[2], "%u", &i);
  else
    i=1;
  printf("benchmark of \"%s\" :\n", argv[1]);
  if(getenv("DROPCACHES")) {
    FILE *fd = fopen("/proc/sys/vm/drop_caches", "w");
    if(fd != NULL) {
      fprintf(fd, "1");
      fclose(fd);
    }
  }
  gettimeofday(&tv1, NULL);
  start = rdtsc();
  for(; i>0; --i) {
    system(argv[1]);
  }
  end = rdtsc();
  gettimeofday(&tv2, NULL);
  printf("took: %llu clock cycles, %llu us\n", end-start, timediff(&tv1, &tv2));
  return 0;
}
