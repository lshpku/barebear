#include "lib/syslib.h"
#include "lib/pfc.h"
#include "lib/printf.h"

void print_all_events()
{
    uint64_t event[8];

    __sync_synchronize();
    for (int i = 0; i < 8; i++) {
        event[i] = __read_event(i);
    }
    __sync_synchronize();

    printf("{\n");
    printf("  \"cycle\"    : %d,\n", event[0]);
    printf("  \"instret\"  : %d,\n", event[1]);
    printf("  \"br\"       : %d,\n", event[2]);
    printf("  \"br_misp\"  : %d,\n", event[5]);
    printf("  \"jalr\"     : %d,\n", event[3]);
    printf("  \"jalr_misp\": %d,\n", event[6]);
    printf("  \"ret\"      : %d,\n", event[4]);
    printf("  \"ret_misp\" : %d\n", event[7]);
    printf("}\n");
}

void reset_all_events()
{
    __sync_synchronize();
    for (int i = 0; i < 8; i++) {
        __write_event(i, 0);
    }
    __sync_synchronize();
}

int do_qsort();
void do_matmul();

int main()
{
    __set_eventset(3);

    printf("\"init\": ");
    reset_all_events();
    print_all_events();

    printf("\"do_qsort\": ");
    reset_all_events();
    do_qsort();
    print_all_events();

    printf("\"do_matmul\": ");
    reset_all_events();
    do_matmul();
    print_all_events();
}
