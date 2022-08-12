#include "Windows.h"
#pragma comment(lib, "user32.lib") 


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
{
    MessageBox(NULL, "This messagebox was written in C!", "It's a MessageBox!", MB_OK);
}
