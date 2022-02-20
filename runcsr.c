#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <sys/wait.h>
#include <stdint.h>
#include "lib/csr.h"

struct timespec time1, time2;

void snapshot_hpm(uint64_t b[16])
{
    b[0] = __csrr_cycle();
    b[1] = __csrr_instret();
    b[2] = __csrr_hpmcounter3();
    b[3] = __csrr_hpmcounter4();
    b[4] = __csrr_hpmcounter5();
    b[5] = __csrr_hpmcounter6();
    b[6] = __csrr_hpmcounter7();
    b[7] = __csrr_hpmcounter8();

    b[8] = __csrr_hpmcounter9();
    b[9] = __csrr_hpmcounter10();
    b[10] = __csrr_hpmcounter11();
    b[11] = __csrr_hpmcounter12();
    b[12] = __csrr_hpmcounter13();
    b[13] = __csrr_hpmcounter14();
    b[14] = __csrr_hpmcounter15();
    b[15] = __csrr_hpmcounter16();
}

void print(FILE *file, time_t sec, long usec, uint64_t b[16])
{
    fprintf(file, "{\"time\":%ld.%06ld", sec, usec);
    fprintf(file, ",\"hpms\":[%llu", b[0]);
    for (int i = 1; i < 16; i++)
        fprintf(file, ",%llu", b[i]);
    fprintf(file, "]}\n");
}

void sigalrm_handler(int signo)
{
    clock_gettime(CLOCK_REALTIME, &time2);
    if (time2.tv_nsec < time1.tv_nsec) {
        time2.tv_sec--;
        time2.tv_nsec += 1000000000L;
    }
    time_t sec = time2.tv_sec - time1.tv_sec;
    long usec = (time2.tv_nsec - time1.tv_nsec) / 1000;

    uint64_t b[16];
    snapshot_hpm(b);
    print(stdout, sec, usec, b);
    print(stderr, sec, usec, b);

    if (signo == SIGALRM)
        alarm(60);
}

int main(int argc, char *argv[])
{
    if (argc == 1) {
        fprintf(stderr, "usage: %s executable [args...]\n", argv[0]);
        exit(-1);
    }

    pid_t pid = fork();
    if (pid == 0) {
        for (int i = 1; i < argc; i++)
            argv[i - 1] = argv[i];
        argv[argc - 1] = NULL;
        execvp(argv[0], argv);
    }

    clock_gettime(CLOCK_REALTIME, &time1);
    sigalrm_handler(SIGALRM);
    signal(SIGALRM, sigalrm_handler);

    wait(NULL);
    signal(SIGALRM, SIG_DFL);
    sigalrm_handler(0);
}
