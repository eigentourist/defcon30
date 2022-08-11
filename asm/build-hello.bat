.\set-nasm-path.bat
nasm -f win64 -o hello.obj hello.asm
link hello.obj /subsystem:console /out:hello.exe kernel32.lib legacy_stdio_definitions.lib msvcrt.lib