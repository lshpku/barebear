
static int a[] = {2, -1, -3, 0, -4, -2, 4, 3, -5, 1};

// This is for preventing compiler from optimizing out a.
void update(int i, int j)
{
    a[i] = j;
}

int do_bubble()
{
    int n = sizeof(a) / sizeof(int);

    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (a[i] > a[j]) {
                int tmp = a[i];
                a[i] = a[j];
                a[j] = tmp;
            }
        }
    }

    return a[n - 1];
}

#ifdef WITH_MAIN
#include <stdio.h>
int main()
{
    printf("code = %d\n", do_bubble());
}
#endif
