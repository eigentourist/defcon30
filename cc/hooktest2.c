#include <stdio.h>
#include <windows.h>
#pragma comment(lib, "user32.lib")
#define _WIN32_WINNT 0x050

LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
{
    BOOL fEatKeystroke = FALSE;

    if (nCode == HC_ACTION)
    {
        switch (wParam)
        {
        case WM_KEYDOWN:
        case WM_SYSKEYDOWN:
        case WM_KEYUP:
        case WM_SYSKEYUP:
            PKBDLLHOOKSTRUCT p = (PKBDLLHOOKSTRUCT)lParam;
            if (fEatKeystroke = (p->vkCode == 0x41)) {     //redirect a to b
            printf("Hello a\n");
            keybd_event('B', 0, 0, 0);
            keybd_event('B', 0, KEYEVENTF_KEYUP, 0);
            break;
            }
            break;
        }
    }
    return(fEatKeystroke ? 1 : CallNextHookEx(NULL, nCode, wParam, lParam));
}

int main()
{
    // Install the low-level keyboard & mouse hooks
    HHOOK hhkLowLevelKybd = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, 0, 0);

    // Keep this app running until we're told to stop
    MSG msg;
    while (!GetMessage(&msg, NULL, NULL, NULL)) {    //this while loop keeps the hook
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    UnhookWindowsHookEx(hhkLowLevelKybd);

    return(0);
}