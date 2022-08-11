.\set-nasm-path.bat
nasm -f win64 -o gremlin.obj gremlin.asm
link gremlin.obj /subsystem:console /out:gremlin.exe kernel32.lib legacy_stdio_definitions.lib msvcrt.lib