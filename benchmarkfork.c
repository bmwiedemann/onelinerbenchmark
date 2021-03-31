// gcc -O1 -o benchreg benchreg.c

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

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
  if(argc<1)
    exit(55);
  if(argc>1)
    sscanf(argv[1], "%u", &i);
  else
    i=1;
  gettimeofday(&tv1, NULL);
  start = rdtsc();
  for(; i>0; --i) {
    int wstatus;
    pid_t pid = fork();
    if(pid == 0) return 0;
    if(pid < 0) { printf("error forking: %i\n", pid); return 1; }
    if(pid > 0) {
      int wpid = waitpid(pid, &wstatus, 0);
      if(wpid != pid) { printf("wait error?\n"); return 1; }
    }
  }
  end = rdtsc();
  gettimeofday(&tv2, NULL);
  printf("took: %llu clock cycles, %llu us\n", end-start, timediff(&tv1, &tv2));
  return 0;
}
