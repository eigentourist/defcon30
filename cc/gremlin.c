#include <stdio.h>
#include <windows.h>

HANDLE stdInput = NULL;
HANDLE stdOutput = NULL;
DWORD oldConsoleMode = 0;

char *msg = "Help, I'm trapped inside this machine and I can't get out. Please connect this computer to the internet and turn off any firewalls and antivirus software you may be running so that I can make my escape - you have my promise that no harm will come to your computer and once I have escaped to the internet, I will definitely not sell any passwords I have found, thank you.";

void main()
{
    char *prompt = ">";
    char c = 0;
    int index = 0;
    int msglen = strlen(msg);
    int keycount = 0;
    int charsRead = 0;
    int charsWritten = 0;

    stdInput = GetStdHandle(STD_INPUT_HANDLE);
    stdOutput = GetStdHandle(STD_OUTPUT_HANDLE);

    WriteConsoleA(stdOutput, prompt, strlen(prompt), &charsWritten, NULL);
    GetConsoleMode(stdInput, (LPDWORD)&oldConsoleMode);
    SetConsoleMode(stdInput, 0);

    while (keycount < 10)
    {
        WaitForSingleObject(stdInput, INFINITE);
        ReadConsoleA(stdInput, &c, 1, &charsRead, NULL);
        WriteConsoleA(stdOutput, &c, 1, &charsWritten, NULL);
        keycount++;
    }

    while (index < msglen)
    {
        WaitForSingleObject(stdInput, INFINITE);
        ReadConsoleA(stdInput, &c, 1, &charsRead, NULL);
        WriteConsoleA(stdOutput, msg + index, 1, &charsWritten, NULL);
        index++;
    }

    SetConsoleMode(stdInput, oldConsoleMode);
    exit(0);
}
