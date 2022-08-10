#include <stdio.h>
#include <windows.h>
#pragma comment(lib, "user32.lib")


void SendKey(char c) {
    WORD vkey = VkKeyScanA(c);
    BYTE scan = MapVirtualKeyA(vkey, 0);
    keybd_event(vkey,scan,0,0);
}

void main()
{
    char *msg = "This is a test message.";
    int msglen = 23;
    int index = 0;

    while (index < msglen)
    {
        SendKey(msg[index]);
        index++;
    }
}