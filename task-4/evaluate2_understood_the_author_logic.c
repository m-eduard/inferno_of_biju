#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
    RULES:

    * the expression starts from i
    * the expression ends at the first encounter of a sign

    Supposedly:
    ((a + b) * (c + d)) + (g - f)

*/

int sizeof_int(int n) {
    int size = 0;

    while (n > 0) {
        n /= 10;
        size += 1;
    }

    return size;
}

int expression(char *p, int *i);

// Evaluates "(expression)" or "number" expressions 
int factor(char *p, int *i) {
    int result = 0;

    printf("String 3rd: %s\n", p + *i);

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

    
    // result = expression(left_member) * expression(right_member);

    // return result;
}


// Evaluates "factor" * "factor" or "factor" / "factor" expressions
int term(char *p, int *i) {
    printf("String 2nd: %s\n", p + *i);
    int result = factor(p, i);
    // printf("Term is: %d\n", result);

    int score = 0;

    while (*i < strlen(p) && (p[*i] == '/' || p[*i] == '*')) {
        *i += 1;
        result = (p[*i - 1] == '/') ? result / factor(p, i) : result * factor(p, i);
    }

    // for (int k = *i; k < strlen(p); ++k) {
    //     // if I reach a + / -, I have to end this, because the expression that I had
    //     // to compute ended
    //     if ((p[k] == '+' || p[k] == '-') && score == 0) {
    //         break;
    //     }

    //     if ((p[k] == '/' || p[k] == '*') && score == 0) {
    //         *i = k + 1; 
    //         result = (p[k] == '/') ? result / factor(p, i) : result * factor(p, i);
    //     }

    //     if (p[k] == '(') {
    //         result += 1;
    //     } else if (p[k] == ')') {
    //         result -= 1;
    //     }
    // }

    return result;
}

// Evaluates "term" + "term" or "term" - "term" expressions
int expression(char *p, int *i) {
    printf("String 1st: %s\n", p + *i);
    int orig_start = *i;
    int result = term(p, i);

    int score = 0;

    for (int k = orig_start; k < strlen(p); ++k) {
        // if (*i > k) {
        //     k = *i;
        //     score = 0;
        // }

        // get a complete paranthese sequence
        if ((p[k] == '+' || p[k] == '-') && score == 0) {
            // this is the second(ish) term of the addition
            *i = k + 1;

            printf("called 2nd\n");
            int current = term(p, i);
            printf("current: %d\n", current);
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

int main(void) {
    // char *string = strdup("(((1+2)*10+200)*2)+(2+1)+2");
    char *string = strdup("(1+2)*(3*4/10+1)+(12+2*(3/10))");

    int current_pos = 0;
    printf("The result: %d\n", expression(string, &current_pos));
    printf("%d\n", (1+2)*(3*4/10+1)+(12+2*(3/10)));

    return 0;
}
