# Snax86 

## What is this?

This is a Console Snake Game written in 0x86-32 Assembly Language for Windows Operating System.
The code is assembled using Nasm and linked using LINK.exe (Microsoft Incremental Linker).
The code of the game is directly linked to Kernel32.lib and uses win32 console api functions.

## Gameplay

![Alt Text](/pics/gameplay.gif)


## Building

To create snake.exe without debug symbols

```
make release
```

To create snake-debug.exe with debug symbols

```
make debug
```
