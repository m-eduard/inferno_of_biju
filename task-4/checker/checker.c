#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_LINE 100001

int expression(char *p, int *i);
int term(char *p, int *i);
int factor(char *p, int *i);

int sizeof_int(int n) {
    int size = 0;

    if (n == 0) {
        return 1;
    }

    while (n > 0) {
        n /= 10;
        size += 1;
    }

    return size;
}

int factor(char *p, int *i) {
    int result = 0;

    // to decide either it is an expression, either I can use atoi
    if (p[*i] != '(') {
        result = atoi(p + *i);

        // go past the number
        *i += sizeof_int(result);

        return result;
    }
    
    // get rid of the paranthesis
    *i += 1;
    return expression(p, i);
}

int expression(char *p, int *i) {
    int orig_start = *i;
    int result = term(p, i);

    // a paranthesis was already opened
    int score = 0;

    for (int k = orig_start; p[k] != '\0'; ++k) {
        if (*i > k) {
            k = *i;
            score = 0;
        }

        // get a complete paranthese sequence
        if ((p[k] == '+' || p[k] == '-') && score == 0) {
            // this is the second(ish) term of the addition
            *i = k + 1;

            int current = term(p, i);
            result = (p[k] == '+') ? result + current : result - current;
        }

        if (p[k] == '(') {
            score += 1;
        } else if (p[k] == ')') {
            score -= 1;
        }

        // this resulted by a call from a subsequence that was inside paranthesis,
        // so when the last closing paranthesis is reached, the evaluated expression has to end
        if (score < 0) {
            // go past the enclosing brace
            *i += 1;
            break;
        }
    }

    return result;
}

int term(char *p, int *i) {
    int result = factor(p, i);

    // *i will never exceed strlen(p)
    while (p[*i] == '/' || p[*i] == '*') {
        *i += 1;
        result = (p[*i - 1] == '/') ? result / factor(p, i) : result * factor(p, i);
    }

    return result;
}

int main()
{
    char s[MAX_LINE];
    char *p;
    int i = 0;  
    scanf("%s", s);
    p = s;
    printf("%d\n", expression(p, &i));
    return 0;
}
