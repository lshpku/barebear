#ifndef __CSR_H__
#define __CSR_H__
#include <stdint.h>

#define DEFINE_CSRR(s)                     \
    static inline uint64_t __csrr_##s()    \
    {                                      \
        uint64_t value;                    \
        __asm__ volatile("csrr    %0, " #s \
                         : "=r"(value)     \
                         :);               \
        return value;                      \
    }

DEFINE_CSRR(cycle)
DEFINE_CSRR(instret)

#define DEFINE_CSRR_HPMCOUNTER(i) DEFINE_CSRR(hpmcounter##i)

DEFINE_CSRR_HPMCOUNTER(3)
DEFINE_CSRR_HPMCOUNTER(4)
DEFINE_CSRR_HPMCOUNTER(5)
DEFINE_CSRR_HPMCOUNTER(6)
DEFINE_CSRR_HPMCOUNTER(7)
DEFINE_CSRR_HPMCOUNTER(8)
DEFINE_CSRR_HPMCOUNTER(9)
DEFINE_CSRR_HPMCOUNTER(10)
DEFINE_CSRR_HPMCOUNTER(11)
DEFINE_CSRR_HPMCOUNTER(12)
DEFINE_CSRR_HPMCOUNTER(13)
DEFINE_CSRR_HPMCOUNTER(14)
DEFINE_CSRR_HPMCOUNTER(15)
DEFINE_CSRR_HPMCOUNTER(16)

#undef DEFINE_CSRR
#undef DEFINE_CSRR_HPMCOUNTER

#endif
