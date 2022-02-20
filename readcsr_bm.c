#include "lib/syslib.h"
#include "lib/csr.h"
#include "lib/printf.h"

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

void print_hpm(const uint64_t b1[16], const uint64_t b2[16])
{
    printf("{\n");
    printf("  \"cycle\"    : %d,\n", b2[0] - b1[0]);
    printf("  \"instret\"  : %d,\n", b2[1] - b1[1]);
    printf("  \"br\"       : %d,\n", b2[2] - b1[2]);
    printf("  \"br_misp\"  : %d,\n", b2[5] - b1[5]);
    printf("  \"jalr\"     : %d,\n", b2[3] - b1[3]);
    printf("  \"jalr_misp\": %d,\n", b2[6] - b1[6]);
    printf("  \"ret\"      : %d,\n", b2[4] - b1[4]);
    printf("  \"ret_misp\" : %d,\n", b2[7] - b1[7]);
    printf("  \"jalr_nret_btb_hit\" : %d,\n", b2[8] - b1[8]);
    printf("  \"jalr_nret_btb_misp\": %d,\n", b2[9] - b1[9]);
    printf("  \"br_bim_misp\"       : %d,\n", b2[11] - b1[11]);
    printf("  \"br_tage_hit\"       : %d,\n", b2[12] - b1[12]);
    printf("  \"br_tage_misp\"      : %d,\n", b2[13] - b1[13]);
    printf("  \"br_loop_hit\"       : %d,\n", b2[10] - b1[10]);
    printf("  \"br_loop_flip\"      : %d,\n", b2[14] - b1[14]);
    printf("  \"br_loop_flip_misp\" : %d\n", b2[15] - b1[15]);
    printf("}\n");
}

int do_qsort();
int do_matmul();
int do_switch();
int do_fordfulk();

#define DO(f)                  \
    snapshot_hpm(b1);          \
    do_##f();                  \
    snapshot_hpm(b2);          \
    printf("\"do_" #f "\": "); \
    print_hpm(b1, b2);

int main()
{
    uint64_t b1[16], b2[16];

    printf("begin\n");
    DO(qsort);
    DO(matmul);
    DO(switch);
    DO(fordfulk);
}
