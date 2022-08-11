.\set-nasm-path.bat
nasm -f win64 msgbox.asm
link msgbox.obj /subsystem:windows /out:msgbox.exe kernel32.lib user32.lib msvcrt.lib