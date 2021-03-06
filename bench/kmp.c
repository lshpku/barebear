#define MAXN 1024

static char text[MAXN] =
    "0120021000101001221120022210120112012001111010102211020222210110212212001120021000002110000012022200"
    "0122021010221022012100121121201202022211012121000121212111100102202021012101000021110010211102101000"
    "0002010220112201102110210012112221021020222011022101001020201111220001211220121000220112102100002010"
    "2222220220020000011211101111122020200122112112222110102222211110212002120010011210000012112221202000"
    "2202000010122110022200100111121122120010110221000002002121210022212121000210111020011122101112120101"
    "2120022211120011121120122221012100102110100011212020102202010120220121012200112221222002020111222120"
    "0020101022012100101122222112012201120210012210212111001220201120210110022112200212000211101000110220"
    "1221010212220122220120110221222001202111202021220202202011211112101100012122212212101202201001122111"
    "1011222121101221200001120200222201020221202101121100000022001200221022200202001201222211111112102201"
    "2210111112221020211112200200220020010112220020012002012122111210202120001110111120202122102220112010";
static char patt[MAXN] = "11202021221";
static int lps[MAXN];

void set_patt(int i, char c) { patt[i] = c; }
void set_text(int i, char c) { text[i] = c; }

static void computeLPSArray()
{
    int len = 0, i = 1;
    lps[0] = 0;

    while (patt[i]) {
        if (patt[i] == patt[len]) {
            len++;
            lps[i] = len;
            i++;
        } else {
            if (len != 0) {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
}

static int strLen(char *s)
{
    int i = 0;
    while (s[i])
        i++;
    return i;
}

int do_kmp()
{
    computeLPSArray();

    int i = 0, j = 0;
    int M = strLen(patt), N = strLen(text);
    int count = 0;

    while (i < N) {
        if (patt[j] == text[i]) {
            j++;
            i++;
        }

        if (j == M)
            return i - j;

        else if (i < N && patt[j] != text[i]) {
            if (j != 0)
                j = lps[j - 1];
            else
                i = i + 1;
        }
    }

    return count;
}

#ifdef WITH_MAIN
#include <stdio.h>
int main()
{
    printf("code = %d\n", do_kmp());
}
#endif
