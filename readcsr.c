#include "lib/bblib.h"

DEFINE_CSRR(mhpc5, 0xb05)
DEFINE_CSRW(mhpc5, 0xb05)
DEFINE_CSRW(hpe5, 0x325)

int main()
{
    for (int i = 0; i < 4; i++) {
        if (i % 2 == 0) {
            __csrw_hpe5(((-1) << 8) | 2);
        } else {
            __csrw_hpe5(0);
        }

        int a = __csrr_mhpc5();
        printf("mhpc5 = %d\n", a);
    }
}
