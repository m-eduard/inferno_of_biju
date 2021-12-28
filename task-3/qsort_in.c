#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int cmp(const void *a, const void *b) {
    printf("%s %lu, %s %lu\n", *(char **)a, strlen(a), *(char **)b, strlen(b));

    if (strlen(a) > strlen(b)) return 1;
    if (strlen(a) < strlen(b)) return -1;

    return 0;

    return strcmp((char *)a, (char *)b);
}

int main(void) {
    char **string = calloc(sizeof(char *), 9);

    // for (int i = 0; i < 9; ++i) {
    //     string[i] = calloc(sizeof(char), 20);
    // }

    string[0] = strdup("Ana");
    string[1] = strdup("are");
    string[2] = strdup("27");
    string[3] = strdup("de");
    string[4] = strdup("mere");
    string[5] = strdup("si");
    string[6] = strdup("32");
    string[7] = strdup("de");
    string[8] = strdup("pere");

    for (int i = 0; i < 9; ++i) {
        printf("%s ", string[i]);
    }

    printf("\n");

    qsort(string, 9, 8, cmp);

    for (int i = 0; i < 9; ++i) {
        printf("%s ", string[i]);
    }

    return 0;
}
