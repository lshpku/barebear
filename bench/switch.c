

static int sw(int i, int j)
{
    if (j <= 0)
        return i;
    switch (i) {
    case 0:
        return sw(7, j - 1) + sw(4, j - 1);
    case 1:
        return sw(3, j - 1) + sw(5, j - 1);
    case 2:
        return sw(2, j - 1) + sw(6, j - 1);
    case 3:
        return sw(6, j - 1) + sw(2, j - 1);
    case 4:
        return sw(5, j - 1) + sw(0, j - 1);
    case 5:
        return sw(1, j - 1) + sw(7, j - 1);
    case 6:
        return sw(0, j - 1) + sw(1, j - 1);
    case 7:
        return sw(4, j - 1) + sw(3, j - 1);
    }
    return 0;
}

int do_switch()
{
    return sw(4, 12);
}
