nasm -f win64 -o factorial.obj factorial.asm
link factorial.obj /subsystem:console /out:factorial.exe kernel32.lib legacy_stdio_definitions.lib msvcrt.lib