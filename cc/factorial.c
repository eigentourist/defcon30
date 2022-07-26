#include <stdio.h>
#include <windows.h>
#pragma comment(lib, "factorial_test.lib")

int main(int argc, char **argv)
{
    extern _declspec(dllimport) int factorial();
    HINSTANCE hInst = LoadLibrary("factorial_test.dll");

    int result = factorial(5);

    printf("Factorial is: %d", result);
    return 0;
}