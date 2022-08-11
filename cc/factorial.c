#include <stdio.h>

int main(int argc, char **argv)
{
    int n = 5;
    unsigned long long fact = 1;

    for (int i = 1; i <= n; ++i) 
    {
        fact *= i;
    }
    printf("Factorial of %d is: %llu", n, fact);
    
    return 0;
}