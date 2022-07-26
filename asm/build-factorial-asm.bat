nasm -f win64 -o factorial-asm.obj factorial.asm
link factorial-asm.obj /subsystem:console /out:factorial-asm.exe kernel32.lib legacy_stdio_definitions.lib msvcrt.lib