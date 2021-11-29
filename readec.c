#include "lib/bblib.h"

#define DEFINE_REVENT(i)               \
    uint64_t __revent_##i()            \
    {                                  \
        uint64_t result;               \
        asm volatile("add x0, %0, x%1" \
                     : "=r"(result)    \
                     : "I"(i));        \
        return result;                 \
    }

#define DEFINE_WEVENT(i)                    \
    void __wevent_##i(uint64_t value)       \
    {                                       \
        asm volatile("sub x0, %0, x%1"      \
                     :                      \
                     : "r"(value), "I"(i)); \
    }

DEFINE_REVENT(0)
DEFINE_REVENT(1)
DEFINE_REVENT(2)
DEFINE_REVENT(3)
DEFINE_REVENT(4)
DEFINE_REVENT(5)
DEFINE_REVENT(6)
DEFINE_REVENT(7)

DEFINE_WEVENT(0)
DEFINE_WEVENT(1)
DEFINE_WEVENT(2)
DEFINE_WEVENT(3)
DEFINE_WEVENT(4)
DEFINE_WEVENT(5)
DEFINE_WEVENT(6)
DEFINE_WEVENT(7)

void print_all_events()
{
    __sync_synchronize();
    uint64_t event_0 = __revent_0();
    uint64_t event_1 = __revent_1();
    uint64_t event_2 = __revent_2();
    uint64_t event_3 = __revent_3();
    uint64_t event_4 = __revent_4();
    uint64_t event_5 = __revent_5();
    uint64_t event_6 = __revent_6();
    uint64_t event_7 = __revent_7();
    __sync_synchronize();

    printf("{\n");
    printf("  \"cycle\"    : %d,\n", event_0);
    printf("  \"instret\"  : %d,\n", event_1);
    printf("  \"br\"       : %d,\n", event_2);
    printf("  \"br_misp\"  : %d,\n", event_4);
    printf("  \"jalr\"     : %d,\n", event_3);
    printf("  \"jalr_misp\": %d,\n", event_5);
    printf("  \"ret\"      : %d,\n", event_6);
    printf("  \"ret_misp\" : %d\n", event_7);
    printf("}\n");
}

void reset_all_events()
{
    __sync_synchronize();
    __wevent_0(0);
    __wevent_1(0);
    __wevent_2(0);
    __wevent_3(0);
    __wevent_4(0);
    __wevent_5(0);
    __wevent_6(0);
    __wevent_7(0);
    __sync_synchronize();
}

int do_qsort();
int do_matmul();

int main()
{
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
