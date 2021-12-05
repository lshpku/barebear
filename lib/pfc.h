#ifndef __PFC_H__
#define __PFC_H__

#include <stdint.h>
#include <stddef.h>

#define CASE_READ_EVENT(i)             \
    case i:                            \
        asm volatile("add x0, %0, x%1" \
                     : "=r"(result)    \
                     : "I"(i));        \
        break

#define CASE_WRITE_EVENT(i)                 \
    case i:                                 \
        asm volatile("sub x0, %0, x%1"      \
                     :                      \
                     : "r"(value), "I"(i)); \
        break

#define CASE_SET_EVENTSET(i)          \
    case i:                           \
        asm volatile("or x0, x%0, x0" \
                     :                \
                     : "I"(i));       \
        break

inline uint64_t __read_event(int i)
{
    uint64_t result;
    switch (i) {
        CASE_READ_EVENT(0);
        CASE_READ_EVENT(1);
        CASE_READ_EVENT(2);
        CASE_READ_EVENT(3);
        CASE_READ_EVENT(4);
        CASE_READ_EVENT(5);
        CASE_READ_EVENT(6);
        CASE_READ_EVENT(7);
        CASE_READ_EVENT(8);
        CASE_READ_EVENT(9);
        CASE_READ_EVENT(10);
        CASE_READ_EVENT(11);
        CASE_READ_EVENT(12);
        CASE_READ_EVENT(13);
        CASE_READ_EVENT(14);
        CASE_READ_EVENT(15);
    default:
        return 0;
    }
    return result;
}

inline void __write_event(int i, uint64_t value)
{
    switch (i) {
        CASE_WRITE_EVENT(0);
        CASE_WRITE_EVENT(1);
        CASE_WRITE_EVENT(2);
        CASE_WRITE_EVENT(3);
        CASE_WRITE_EVENT(4);
        CASE_WRITE_EVENT(5);
        CASE_WRITE_EVENT(6);
        CASE_WRITE_EVENT(7);
        CASE_WRITE_EVENT(8);
        CASE_WRITE_EVENT(9);
        CASE_WRITE_EVENT(10);
        CASE_WRITE_EVENT(11);
        CASE_WRITE_EVENT(12);
        CASE_WRITE_EVENT(13);
        CASE_WRITE_EVENT(14);
        CASE_WRITE_EVENT(15);
    }
}

inline void __set_eventset(int i)
{
    switch (i) {
        CASE_SET_EVENTSET(0);
        CASE_SET_EVENTSET(1);
        CASE_SET_EVENTSET(2);
        CASE_SET_EVENTSET(3);
        CASE_SET_EVENTSET(4);
        CASE_SET_EVENTSET(5);
        CASE_SET_EVENTSET(6);
        CASE_SET_EVENTSET(7);
        CASE_SET_EVENTSET(8);
        CASE_SET_EVENTSET(9);
        CASE_SET_EVENTSET(10);
        CASE_SET_EVENTSET(11);
        CASE_SET_EVENTSET(12);
        CASE_SET_EVENTSET(13);
        CASE_SET_EVENTSET(14);
        CASE_SET_EVENTSET(15);
    }
}

#endif
