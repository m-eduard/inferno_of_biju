#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
    RULES:

    * the expression starts from i
    * the expression ends at the first encounter of a sign

*/

// Evaluates "factor" * "factor" or "factor" / "factor" expressions
int factor(char *p, int *i) {
    int result = 0;
    
    result = expression(left_member) * expression(right_member);

    return result;
}

// Evaluates "term" + "term" or "term" - "term" expressions 
int term(char *p, int *i) {
    int result = 0;

    int right = expression();
    int left = expression();

    result = right + left;

    return result;
}

// Evaluates "(expression)" or "number" expressions 
int expression(char *p, int *i) {
    int result = 0;

    // result is the temporary result for the operations performed

    // search for any sign
    for (int k = *i; k < strlen(p); ++k) {
        if (p[k] == '+' || p[k] == '-') {
            // result = (p[k] == '+') ? result + term(p, i) : result - term(p, i);
            result = term(p, i);
        }

        if (p[k] == '*' || p[k] == '/') {
            // result = (p[k] == '*') ? result * factor(p, i) : result * factor(p, i);
            result = factor(p, i);
        }
    }

    return result;
}

int main(void) {
    char *string = strdup("(12 + 2) * 10");

    int current_pos = 0;
    printf("The result: %d\n", expression(string, &current_pos));

    return 0;
}
