#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <sys/wait.h>
#include <stdint.h>
#include "lib/csr.h"

struct timespec time1, time2;

#define READ_HPM(i) b[i - 1] = __csrr_hpmcounter##i()

void snapshot_hpm(uint64_t b[31])
{
    b[0] = __csrr_cycle();
    b[1] = __csrr_instret();
    READ_HPM(3);
    READ_HPM(4);
    READ_HPM(5);
    READ_HPM(6);
    READ_HPM(7);
    READ_HPM(8);
    READ_HPM(9);
    READ_HPM(10);
    READ_HPM(11);
    READ_HPM(12);
    READ_HPM(13);
    READ_HPM(14);
    READ_HPM(15);
    READ_HPM(16);
    READ_HPM(17);
    READ_HPM(18);
    READ_HPM(19);
    READ_HPM(20);
    READ_HPM(21);
    READ_HPM(22);
    READ_HPM(23);
    READ_HPM(24);
    READ_HPM(25);
    READ_HPM(26);
    READ_HPM(27);
    READ_HPM(28);
    READ_HPM(29);
    READ_HPM(30);
    READ_HPM(31);
}

void print(FILE *file, time_t sec, long usec, uint64_t b[31])
{
    fprintf(file, "{\"time\":%ld.%06ld", sec, usec);
    fprintf(file, ",\"hpms\":[%llu", b[0]);
    for (int i = 1; i < 31; i++)
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

    uint64_t b[31];
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
