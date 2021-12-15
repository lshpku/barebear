#include "lib/case.h"

BEGIN_TEST()

  # Modify 0(pc) and execute again
  mv    a0, zero
  li    a3, 37
  li    a4, 61
  la    a1, __add
  lwu   a2, 0(a1)
1: 
  ENTER_UNICORE()
  ADD(a5, a3, a4)
  STW(a2, x31, a0)
  ADD(a6, a2, a1)
  EXIT_UNICORE()
  bne   a0, zero, 2f
  fence.i
  j     1b
2:
  li    a2, 98
  MATCH(a0, a2)

END_TEST()

__add:
  ADD(a0, a3, a4)
