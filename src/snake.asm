; -------------------- Snake.asm ------------------
; A console snake game written by Ori Damari 0xFF 
; 0x86 Assembly 32bit 
; Windows Operating System
; Nasm Syntax
; -------------------------------------------------

global _main

; --------------- external functions ---------------
extern _SetConsoleTextAttribute@8
; Returns BOOL
;_In_ HANDLE hConsoleOutput,
;_In_ WORD   wAttributes 


extern _Sleep@4
; Returns VOID
;  _In_ DWORD dwMilliseconds

extern  _GetStdHandle@4
; Returns HANDLE
;  _In_ DWORD nStdHandle

extern  _WriteFile@20
; Returns BOOL
;  _In_        HANDLE       hFile,
;  _In_        LPCVOID      lpBuffer,
;  _In_        DWORD        nNumberOfBytesToWrite,
;  _Out_opt_   LPDWORD      lpNumberOfBytesWritten,
;  _Inout_opt_ LPOVERLAPPED lpOverlapped

extern  _ExitProcess@4
 ; Returns DWORD 
 ;_In_ UINT uExitCode
 


extern _FormatMessageA@28
; Returns DWORD
;_In_     DWORD   dwFlags,
;_In_opt_ LPCVOID lpSource,
;_In_     DWORD   dwMessageId,
;_In_     DWORD   dwLanguageId,
;_Out_    LPTSTR  lpBuffer,
;_In_     DWORD   nSize,
;_In_opt_ va_list *Arguments

extern _GetLastError@0
; Returns DWORD

extern _GetSystemDefaultLangID@0
; Returns LANGID (WORD)

extern _FillConsoleOutputCharacterA@20
; Returns BOOL 
;_In_  HANDLE  hConsoleOutput,
;_In_  TCHAR   cCharacter,
;_In_  DWORD   nLength,
;_In_  COORD   dwWriteCoord,
;_Out_ LPDWORD lpNumberOfCharsWritten

extern _GetConsoleScreenBufferInfo@8 
; Returns BOOL
;_In_ HANDLE hConsoleOutput, 
;_Out_ PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo 

extern _SetConsoleCursorPosition@8
; Returns BOOL
;_In_ HANDLE hConsoleOutput,
;_In_ COORD  dwCursorPosition

extern _SetConsoleCursorInfo@8
; Returns BOOL
; _In_       HANDLE              hConsoleOutput,
; _In_ const CONSOLE_CURSOR_INFO *lpConsoleCursorInfo

extern _GetConsoleCursorInfo@8
; Returns BOOL
; _In_  HANDLE               hConsoleOutput,
; _Out_ PCONSOLE_CURSOR_INFO lpConsoleCursorInfo

extern _SetConsoleCtrlHandler@8
; Returns BOOL 
;  _In_opt_ PHANDLER_ROUTINE HandlerRoutine,
;  _In_     BOOL             Add

extern _SetConsoleMode@8
; Returns BOOL
;  _In_ HANDLE hConsoleHandle,
;  _In_ DWORD  dwMode


extern _GetNumberOfConsoleInputEvents@8
; Returns BOOL 
;_In_  HANDLE  hConsoleInput,
;_Out_ LPDWORD lpcNumberOfEvents


extern _ReadConsoleInputA@16
; Returns BOOL
; _In_  HANDLE        hConsoleInput,
; _Out_ PINPUT_RECORD lpBuffer,
; _In_  DWORD         nLength,
; _Out_ LPDWORD       lpNumberOfEventsRead

extern _HeapFree@12
;  Returns DWORD
;  ERROR returns zero
;  _In_ HANDLE hHeap,
;  _In_ DWORD  dwFlags,
;  _In_ LPVOID lpMem


extern _GetProcessHeap@0
; Returns HANDLE
; ERROR Returns NULL

extern _GetTickCount@0
; Returns DWORD

extern _GetSystemTime@4
; LPSYSTEMTIME lpSystemTime

extern _FillConsoleOutputAttribute@20
;  _In_  HANDLE  hConsoleOutput,
;  _In_  WORD    wAttribute,
;  _In_  DWORD   nLength,
;  _In_  COORD   dwWriteCoord,
;  _Out_ LPDWORD lpNumberOfAttrsWritten


; ------------------- Structures --------------------

; COORD {
; WORD X; 0
; WORD Y; 2
; } 4

; SMALL_RECT {
;  SHORT Left; 0
;  SHORT Top; 2
;  SHORT Right; 4
;  SHORT Bottom; 6
; } 8

; CONSOLE_SCREEN_BUFFER_INFO {
;  COORD dwSize; 0
;  COORD dwCursorPosition 4
;  WORD wAttributes 8
;  SMALL_RECT srWindow 10
;  COORD dwMaximumWindowSize 18
;} 22

; CONSOLE_CURSOR_INFO { 
;   DWORD dwSize; 0
;   BOOL bVisible; 4
;} 8

; INPUT_RECORD { 
;   WORD EventType; 0
;	union {  4
;		KEY_EVENT_RECORD          KeyEvent;
;       MOUSE_EVENT_RECORD        MouseEvent;
;		WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
;		MENU_EVENT_RECORD         MenuEvent;
;		FOCUS_EVENT_RECORD        FocusEvent;	
;   } 
; } 20

; FOCUS_EVENT_RECORD {
;   BOOL bSetFocus; 0
; }  4

; WINDOW_BUFFER_SIZE_RECORD {
;   COORD dwSize; 0
; } 4

; KEY_EVENT_RECORD {
;   BOOL  bKeyDown; 0
;   WORD  wRepeatCount; 4
;   WORD  wVirtualKeyCode; 6
;   WORD  wVirtualScanCode; 8
;   union { 10
;     WCHAR UnicodeChar; 
;     CHAR  AsciiChar; 
;   } uChar; 2
;   DWORD dwControlKeyState; 12
;} 16

; MENU_EVENT_RECORD { 
;   UINT dwCommandId; 0
; } 4

; SYSTEMTIME { 
;  WORD wYear; 0
;  WORD wMonth; 2 
;  WORD wDayOfWeek; 4
;  WORD wDay; 6
;  WORD wHour; 8
;  WORD wMinute; 10
;  WORD wSecond; 12
 ; WORD wMilliseconds; 14
; } 16


; MOUSE_EVENT_RECORD { 
;  COORD dwMousePosition; 0
;  DWORD dwButtonState; 4
;  DWORD dwControlKeyState; 8
;  DWORD dwEventFlags; 12
; } 16


; BOOL WINAPI HandlerRoutine(
;  _In_ DWORD dwCtrlType
; );

; -----------------------------------------------------
section .data

; ------------ win32 constants -------------------------------

; Simple Types
NULL  equ 0
TRUE  equ 1
FALSE equ 0

; FormatMessage
FORMAT_MESSAGE_ALLOCATE_BUFFER equ 0x00000100
FORMAT_MESSAGE_ARGUMENT_ARRAY  equ 0x00002000
FORMAT_MESSAGE_FROM_HMODULE    equ 0x00000800
FORMAT_MESSAGE_FROM_STRING     equ 0x00000400
FORMAT_MESSAGE_FROM_SYSTEM     equ 0x00001000
FORMAT_MESSAGE_IGNORE_INSERTS  equ 0x00000200

; Standard Handles
INVALID_HANDLE_VALUE equ -1
STD_INPUT_HANDLE equ     -10
STD_OUTPUT_HANDLE equ    -11
STD_ERROR_HANDLE equ     -12

; Console Text Attributes
FOREGROUND_BLUE        equ 0x0001 
FOREGROUND_GREEN       equ 0x0002 
FOREGROUND_RED         equ 0x0004 
FOREGROUND_INTENSITY   equ 0x0008 
BACKGROUND_BLUE        equ 0x0010 
BACKGROUND_GREEN       equ 0x0020 
BACKGROUND_RED         equ 0x0040 
BACKGROUND_INTENSITY   equ 0x0080 
ATTRIBUTES_COLOR_CLEAR equ 0xFF00

COMMON_LVB_LEADING_BYTE    equ 0x0100
COMMON_LVB_TRAILING_BYTE   equ 0x0200
COMMON_LVB_GRID_HORIZONTAL equ 0x0400
COMMON_LVB_GRID_LVERTICAL  equ 0x0800
COMMON_LVB_GRID_RVERTICAL  equ 0x1000
COMMON_LVB_REVERSE_VIDEO   equ 0x4000
COMMON_LVB_UNDERSCORE      equ 0x8000

; Ctrl Types
CTRL_C_EVENT        equ 0
CTRL_BREAK_EVENT    equ 1
CTRL_CLOSE_EVENT    equ 2
CTRL_LOGOFF_EVENT   equ 5
CTRL_SHUTDOWN_EVENT equ 6


; Virtual Key Codes
VK_LEFT         equ 25H
VK_UP           equ 26H
VK_RIGHT        equ 27H
VK_DOWN         equ 28H


; INPUT_RECORD EventTypes
FOCUS_EVENT 			 equ 0x0010
KEY_EVENT   			 equ 0x0001
MENU_EVENT  			 equ 0x0008
MOUSE_EVENT 			 equ 0x0002
WINDOW_BUFFER_SIZE_EVENT equ 0x0004

; Console Modes
ENABLE_PROCESSED_INPUT equ 1
ENABLE_LINE_INPUT      equ 2
ENABLE_ECHO_INPUT      equ 4
ENABLE_WINDOW_INPUT    equ 8
ENABLE_MOUSE_INPUT     equ 16
ENABLE_EXTENDED_FLAGS  equ 0x80
ENABLE_INSERT_MODE     equ 0x20
ENABLE_QUICK_EDIT_MODE equ 0x40


; ------------- Application Constants -----------------------------
CONSOLE_MODE             equ ENABLE_EXTENDED_FLAGS 
FORMAT_MESSAGE_NORMAL    equ FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS 
CONSOLE_ATTRIBUTES       equ 0x0007
SNAKE_DIRECTION_DOWN     equ 0x00010000 ; y=1, x=0
SNAKE_DIRECTION_UP       equ 0xFFFF0000  ; y=-1, x=0
SNAKE_DIRECTION_LEFT     equ 0xFFFFFFFF    ; y=0, x=-1
SNAKE_DIRECTION_RIGHT    equ 0x00000001  ; y=0, x=1
SNAKE_CHARACTER          equ 'O'
SNAKE_SPEED_RATE	     equ 2
SNAKE_DEFAULT_LENGTH     equ 6
SNAKE_DEFAULT_X          equ 10
SNAKE_DEFAULT_Y          equ 10
SNAKE_DEFAULT_POINT      equ (SNAKE_DEFAULT_Y << 16) | SNAKE_DEFAULT_X
SNAKE_DEFAULT_DIRECTION  equ SNAKE_DIRECTION_RIGHT
SNAKE_COLOR              equ FOREGROUND_GREEN | FOREGROUND_INTENSITY
GAME_STATE_COLOR         equ FOREGROUND_GREEN | FOREGROUND_INTENSITY
APPLE_COLOR 			 equ FOREGROUND_RED | FOREGROUND_INTENSITY
APPLE_CHAR				 equ '@'
FRAME_COLOR				 equ FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_INTENSITY | BACKGROUND_RED
FRAME_CHAR				 equ '#'
SNAKE_DIRECTION_POS_X    equ 0
SNAKE_DIRECTION_POS_Y    equ 0
SNAKE_DIRECTION_POS 	 equ (SNAKE_DIRECTION_POS_Y << 16) | SNAKE_DIRECTION_POS_X
GAME_SCORE_POS_X 		 equ 0
GAME_SCORE_POS_Y		 equ 0
GAME_SCORE_POS			 equ (GAME_SCORE_POS_Y << 16) | GAME_SCORE_POS_X
SNAKE_DEFAULT_SLEEP_TIME equ 100
FRAME_TOP_DISTANCE 		 equ 3
FRAME_BOTTOM_DISTANCE	 equ 0
FRAME_LEFT_DISTANCE 	 equ 0
FRAME_RIGHT_DISTANCE	 equ 0
GAME_OVER_SLEEP_TIME	 equ 5*1000
GAME_OVER_MESSAGE_COLOR  equ FOREGROUND_GREEN | FOREGROUND_INTENSITY
GAME_OVER_MESSAGE_POS    equ 0

; ------------- strings -------------------------------------

gameScoreMessage db "Score: ", 0
gameScoreMessageLength equ ($ - gameScoreMessage - 1)

directionUp db "Up", 0
directionUpLength equ ($ - directionUp - 1)

directionDown db "Down", 0
directionDownLength equ ($ - directionDown - 1)

directionLeft db "Left", 0
directionLeftLength equ ($ - directionLeft - 1)

directionRight db "Right", 0
directionRightLength equ ($ - directionRight - 1)

unknown db "Unknown", 0
crlfBuff db 13, 10 ; '\r\n'

gameOverMessage db "Game Over! Your Score Is ", 0
gameOverMessageLength equ ($ - gameOverMessage - 1)


; ------------ globals --------------------------------------

; Console Handles
hStdOut dd 0
hStdErr dd 0
hStdIn dd 0
screenBufferSize:
screenBufferWidth dw 0
screenBufferHeight dw 0
windowSize:
windowWidth dw 0
windowHeight dw 0
hCurrentOutput dd 0	
decimalCharactersBuffer times 10 db 0
decimalCharactersBufferLength equ ($ - decimalCharactersBuffer)
randomSeed dd 0


; Error Flag
fatalFlag db 0

characterToWrite db 0
lastKeyCode dw 0
defaultConsoleAttributes dw 0
defaultConsoleCursorInfo times 2 dw 0

; Snake { 
;     DWORD dwLength;
;     SnakeDirection dDirection;
;     SnakePart dwPoints[255];
;}

; SnakePart { 
;    COORD point;
; }

; SnakeDirection { 
;    WORD X;
;    WORD Y;
;}

; KeyInput { 
;	byte isKeyDown;
;   word virtualKeyCode
;   byte padding;
; }

snakeLength dd 0
snakeDirection dd 0
snakePoints times 255 dd 0
snakeSleepTime dd 0
applePosition dd 0
gameScore dd 0
frame:
frameBottom dw 0
frameTop dw 0
frameLeft dw 0
frameRight dw 0


section .text

_main:
	; and esp, 0xFFFFFFF0 ; align the stack to 16 bytes
	call InitializeApplication
	call GameMain
	call ReleaseApplicationResources
	jmp ExitApplication

; ---------------------- Application Procedures --------------------

GameMain:
	call PrintFrame
	call SetApple
	
	.game_loop:
		call PrintGameState
		call PrintSnake
		call CheckSnake
		test eax, eax
		jz .game_over
		call SnakeSleep
		call ClearSnake
		call ProcessInput
		call StepSnake
		call CheckAppleEat
		jmp .game_loop
		
.game_over:
	call GameOver
	ret

GameOver:
	call ClearSnake
	call PrintGameOver
	push dword GAME_OVER_SLEEP_TIME
	call _Sleep@4
	ret
	
InitializeApplication:
	call InitializeConsole
	call InitializeSnake
	call InitializeFrame
	call InitializeRandom
	ret
	
ReleaseApplicationResources:
	call DisposeConsole
	ret
	
ExitApplication:
	push 0
	jmp _ExitProcess@4
	
ReleaseApplication:
	call ReleaseApplicationResources
	jmp ExitApplication
	
FatalError:
	test byte [fatalFlag], 1
	jnz ExitApplication
	inc byte [fatalFlag]
	call ReleaseApplicationResources
	call PrintLastError
	jmp ExitApplication
	
	
; ---------------------- Snake Procedures -----------------------

InitializeSnake:
	mov dword [snakeLength], SNAKE_DEFAULT_LENGTH
	mov dword [snakeDirection], SNAKE_DEFAULT_DIRECTION
	mov dword [snakeSleepTime], SNAKE_DEFAULT_SLEEP_TIME
	mov eax, SNAKE_DEFAULT_POINT
	mov edx, dword [snakeLength]
	
	.init_points:
		dec edx
		mov dword [snakePoints+edx*4], eax 		
		add eax, SNAKE_DEFAULT_DIRECTION
		test edx, edx
		jnz .init_points
		
	ret

InitializeFrame:
	mov word [frameLeft], FRAME_LEFT_DISTANCE
	mov ax, word [windowWidth]
	sub ax, FRAME_RIGHT_DISTANCE
	mov word [frameRight], ax
	mov word [frameTop], FRAME_TOP_DISTANCE
	mov ax, word [windowHeight]
	sub ax, FRAME_BOTTOM_DISTANCE
	mov word [frameBottom], ax
	ret
	
IncreaseSnakeLength:
	mov edx, dword [snakeLength]
	mov eax, dword [snakePoints+edx*4-4]
	mov dword [snakePoints+edx*4], eax
	inc dword [snakeLength]
	inc dword [gameScore]
	sub dword [snakeSleepTime], SNAKE_SPEED_RATE
	ret

SnakeSleep:
	push dword [snakeSleepTime]
	call _Sleep@4
	ret
	
CheckAppleEat:
	mov eax, dword [applePosition]
	cmp eax, dword [snakePoints]
	jne .return
	call IncreaseSnakeLength
	call SetApple
	
.return:
	ret

PrintGameOver:
	push ebx
	mov bx, GAME_OVER_MESSAGE_COLOR
	call SetCursorColor
	pop ebx
	
	push gameOverMessageLength ; len
	push GAME_OVER_MESSAGE_POS ; pos
	push gameOverMessage 	   ; msg
	call WriteStringPosLen
	mov eax, dword [gameScore]
	call WriteDec
	ret
	
PrintFrame:
	push ebp
	push ebx
	mov bx, FRAME_COLOR
	call SetCursorColor
	pop ebx
	sub esp, 16 ; topLeft+0, topRight+4, bottomLeft+8, bottomRight+12
	
	mov word [esp], FRAME_LEFT_DISTANCE ; topLeft.X
	mov word [esp+2], FRAME_TOP_DISTANCE ; topLeft.Y
	
	mov ax, word [windowWidth]
	sub ax, FRAME_RIGHT_DISTANCE
	mov word [esp+4], ax ; topRight.X	
	mov word [esp+12], ax ; bottomRight.X
	mov word [esp+6], FRAME_TOP_DISTANCE ;topRight.Y
	
	mov word [esp+8], FRAME_LEFT_DISTANCE
	mov ax, word [windowHeight] 
	sub ax, FRAME_BOTTOM_DISTANCE
	mov word [esp+10], ax ; bottomLeft.Y
	mov word [esp+14], ax  ; bottomRight.Y
	
	mov ebp, esp
	
	; Top Line
	push dword SNAKE_DIRECTION_RIGHT ; direction
	push dword [ebp+4]	; endPosition=topRight
	push dword [ebp] ; startPosition=topLeft
	call PrintFrameLine
	
	; Left Line
	push dword SNAKE_DIRECTION_DOWN ; direction
	push dword [ebp+8] ; endPosition=bottomLeft
	push dword [ebp]   ; startPosition=topLeft
	call PrintFrameLine
	
	; Bottom Line
	push dword SNAKE_DIRECTION_RIGHT ; direction
	push dword [ebp+12] ;endPosition=bottomRight
	push dword [ebp+8] ; startPosition=bottomLeft
	call PrintFrameLine
	
	; Right Line
	push dword SNAKE_DIRECTION_DOWN ; direction
	push dword [ebp+12] ; endPosition=bottomRight
	push dword [ebp+4] ; startPosition=topRight
	call PrintFrameLine
	add esp, 16
	
	pop ebp
	ret 
	
PrintFrameLine: ; __stdcall PrintFrameLine(COORD startPosition+8, COORD endPosition+12, SnakeDirection direction+16);
	push ebp
	mov ebp, esp
	push edi
	push ebx
	mov edi, dword [ebp+8]
	
	.print_block:
		mov eax, edi
		mov bl, FRAME_CHAR
		call WriteCharPos
		add edi, dword [ebp+16]
		cmp edi, dword [ebp+12]
		jne .print_block
		
	pop ebx
	pop edi
	pop ebp
	ret 12
	
SetApple:
	call SetApplePosition
	call PrintApple
	ret
	
PrintApple:
	push ebx
	mov bx, APPLE_COLOR
	call SetCursorColor
	mov bl, APPLE_CHAR
	mov eax, [applePosition]
	call WriteCharPos
	pop ebx
	ret
	
SetApplePosition:
	push ebx
.generate_random:
	movzx eax, word [frameRight]
	push eax ; max
	movzx eax, word [frameLeft]
	inc eax
	push eax ; min
	call GetRandomRange
	mov ebx, eax
	
	movzx eax, word [frameBottom]
	push eax ; max
	movzx eax, word [frameTop]
	inc eax
	push eax ; min
	call GetRandomRange
	xor edx, edx
	shl eax, 16
	mov ax, bx
	
	.check_part:
		cmp dword [edx*4+snakePoints], eax
		je .generate_random
		inc edx
		cmp edx, dword [snakeLength]
		jl .check_part
		
	mov [applePosition], eax
	pop ebx
	ret
		
	
ProcessInput:
	call GetLastKey
	
	cmp ax, VK_UP
	jne .is_down
	mov dword [snakeDirection], SNAKE_DIRECTION_UP
	ret
	
.is_down:
	cmp ax, VK_DOWN
	jne .is_left
	mov dword [snakeDirection], SNAKE_DIRECTION_DOWN
	ret
	
.is_left:
	cmp ax, VK_LEFT
	jne .is_right
	mov dword [snakeDirection], SNAKE_DIRECTION_LEFT
	ret
	
.is_right:
	cmp ax, VK_RIGHT
	jne .return
	mov dword [snakeDirection], SNAKE_DIRECTION_RIGHT
	
.return:
	ret	
	
PrintGameState:
	push ebx
	mov bx, GAME_STATE_COLOR
	call SetCursorColor
	pop ebx
	push dword gameScoreMessageLength ; len
	push dword GAME_SCORE_POS		  ; pos
	push gameScoreMessage 			  ; msg
	call WriteStringPosLen
	mov eax, dword [gameScore]
	call WriteDec
	ret
	
PrintSnakePart: ; eax = SnakePart*
	push ebx
	mov bl, SNAKE_CHARACTER
	mov eax, dword [eax]
	call WriteCharPos
	pop ebx
	ret

ClearSnakePart: ; eax = SnakePart*
	push ebx
	mov bl, ' '
	mov eax, dword [eax]
	call WriteCharPos
	pop ebx
	ret
	
PrintSnake:
	push ebx
	mov bx, SNAKE_COLOR
	call SetCursorColor
	push PrintSnakePart
	call IterateSnake
	pop ebx
	ret
	
ClearSnake:
	push ebx
	mov bx, 0
	call SetCursorColor
	push ClearSnakePart
	call IterateSnake
	pop ebx
	ret

CheckSnake: ; bool CheckSnake()
	mov ax, word [snakePoints] ; head.X
	cmp ax, word [frameLeft]
	jle .snake_error
	cmp ax, word [frameRight]
	jge .snake_error
	mov ax, word [snakePoints+2] ; head.Y
	cmp ax, word [frameTop]
	jle .snake_error
	cmp ax, word [frameBottom]
	jge .snake_error
	
	mov edx, 1
	
	.check_part:
		mov eax, dword [snakePoints+edx*4]
		cmp dword [snakePoints], eax
		je .snake_error
		inc edx
		cmp edx, dword [snakeLength]
		jl .check_part
		
	mov eax, 1
	ret
	
.snake_error:
	xor eax, eax
	ret

StepSnake: ; StepSnake();
	mov eax, dword [snakeLength]
	dec eax
	
	.step_snake:
		mov edx, dword [snakePoints+eax*4-4]
		mov dword [snakePoints+eax*4], edx ; prevPart.point = nextPart.point;
		dec eax
		jnz .step_snake
		
	mov edx, dword [snakeDirection]
	add dword [snakePoints], edx ; snakeHead.point += snakeDirection;
	ret
	
		
IterateSnake: ; __stdcall (SnakePartCallback(eax=SnakePart* p) callback)
	push ebp
	mov ebp, esp
	push ebx
	xor ebx, ebx
	
	jmp .iteration_condition
	
	.next_point:
		lea eax, [snakePoints+ebx*4] ; address of SnakePart
		call dword [ebp+8]
		inc ebx
		
	.iteration_condition:
		cmp ebx, dword [snakeLength]
		jl .next_point
		
	pop ebx
	pop ebp
	ret 4
	
DirectionToString: ; __stdcall (eax=SnakeDirection direction), ret eax=str(direction)
	cmp eax, SNAKE_DIRECTION_UP
	je .return_up
	cmp eax, SNAKE_DIRECTION_DOWN
	je .return_down
	cmp eax, SNAKE_DIRECTION_LEFT
	je .return_left
	cmp eax, SNAKE_DIRECTION_RIGHT
	je .return_right
	mov eax, unknown
	ret
.return_up:
	mov eax, directionUp
	ret
.return_left:
	mov eax, directionLeft
	ret
.return_right:
	mov eax, directionRight
	ret
.return_down:
	mov eax, directionDown
	ret
	
; -------------------- Randomization --------------------------

InitializeRandom:
	call GetSystemMiliseconds
	mov dword [randomSeed], eax
	ret
	
GetSystemMiliseconds:
	sub esp, 16
	push esp
	call _GetSystemTime@4
	movzx eax, word [esp+14]
	add esp, 16
	ret
	
GetRandom: ; eax = random 32bit
	mov eax, 0x343fd
	imul dword [randomSeed]
	add eax, 0x269ec1
	mov dword [randomSeed], eax
	ror eax, 8
	ret
	
GetRandomRange: ;  GetRandomRange(int min+8, int max+12)
	push ebp
	mov ebp, esp
	call GetRandom
	xor edx, edx
	mov ecx, dword [ebp+12]
	sub ecx, dword [ebp+8] ; ecx = (max - min)
	div ecx
	mov eax, edx			; eax %= ecx;
	add eax, dword [ebp+8] ; eax += min;
	pop ebp
	ret 8
	
; -------------------- Console Procedures ----------------------

InitializeConsole:
	; set stdoutput
	push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
	mov [hStdOut], eax
	mov [hCurrentOutput], eax
	
	; set stderr
	push STD_ERROR_HANDLE 
	call _GetStdHandle@4
	mov [hStdErr], eax
	
	; set stdinput
	push STD_INPUT_HANDLE
	call _GetStdHandle@4
	mov [hStdIn], eax

	push defaultConsoleCursorInfo ; lpConsoleCursorInfo
	push dword [hCurrentOutput] ; hConsole
	call _GetConsoleCursorInfo@8 
	test eax, eax
	jz FatalError
	
	mov eax, TRUE
	call SetSignalHandler

	sub esp, 24 ; CONSOLE_SCREEN_BUFFER_INFO
	push esp
	push dword [hCurrentOutput]
	call _GetConsoleScreenBufferInfo@8
	test eax, eax
	jz FatalError
	
	mov ax, word [esp]
	mov word [screenBufferWidth], ax
	mov ax, word [esp+2]
	mov word [screenBufferHeight], ax
	
	mov ax, word [esp+16]
	mov word [windowHeight], ax
	mov ax, word [esp+14]
	mov word [windowWidth], ax
	
	; save last attributes
	mov ax, word [esp+8]
	mov word [defaultConsoleAttributes], ax
	
	; free console buffer
	add esp, 24
	
	call ClearConsoleText
	
	push dword CONSOLE_ATTRIBUTES
	call FillConsoleAttributes
	
	sub esp, 8 ; CONSOLE_CURSOR_INFO
	mov dword [esp], 1 ; dwSize
	mov dword [esp+4], FALSE ; bVisible
	push esp ; lpConsoleCursorInfo
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleCursorInfo@8
	add esp, 8 ; free console cursor
	test eax, eax
	jz FatalError
	
	
	;push dword CONSOLE_MODE ; dwMode
	;push dword [hStdIn] ; hConsoleHandle
	;call _SetConsoleMode@8
	;test eax, eax
	;jz FatalError
	
	ret
	
DisposeConsole:
	call RestoreLastConsoleAttributes
	call RestoreLastConsoleCursor
	mov eax, FALSE
	call SetSignalHandler
	call ClearConsoleText
	ret
	
FillConsoleAttributes: ; __stdcall FillConsoleAttributes(dword attrs+8)
	push ebp
	mov ebp, esp
	sub esp, 4
	push esp ; lpNumberOfAttrsWritten
	push dword 0 ; coord { 0, 0} dwWriteCoord
	movzx eax, word [screenBufferWidth]
	movzx ecx, word [screenBufferHeight]
	mul ecx
	push eax ; nLength
	push dword [ebp+8]; wAttribute
	push dword [hCurrentOutput]
	call _FillConsoleOutputAttribute@20
	add esp, 4
	test eax, eax
	jz FatalError
	pop ebp
	ret 4
	
RestoreLastConsoleAttributes:
	push word 0
	push word [defaultConsoleAttributes] ; wAttributes
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleTextAttribute@8
	test eax, eax
	jz FatalError
	movzx eax, word [defaultConsoleAttributes]
	push dword eax
	call FillConsoleAttributes
	ret

RestoreLastConsoleCursor:
	push defaultConsoleCursorInfo
	push dword [hCurrentOutput]
	call _SetConsoleCursorInfo@8
	test eax, eax
	jz FatalError
	ret
	
SetSignalHandler: ; eax = BOOL set
	push eax ; Add
	push HandlerRoutine ; pHandlerRoutine
	call _SetConsoleCtrlHandler@8
	test eax, eax
	jz FatalError
	ret
	
HandlerRoutine: ; BOOL __stdcall HandlerRoutine(DWORD dwCtrlType)
	call ReleaseApplication
	mov eax, TRUE
	ret 4
	
PrintLastError:
	push ebp
	mov ebp, esp
	sub esp, 4 ; LPSTR lpBuffer;
	push NULL ; Arguments
	push 0 ; nSize
	lea eax, [ebp-4] ; lpBuffer
	push eax
	call _GetSystemDefaultLangID@0
	push eax ; dwLanguageId
	call _GetLastError@0
	push eax ; dwMessageId
	push NULL ; lpSource
	push FORMAT_MESSAGE_NORMAL	; dwFlags
	call _FormatMessageA@28
	
	mov eax, dword [hStdErr]
	mov dword [hCurrentOutput], eax
	push dword [ebp-4] ; msg
	call WriteString
	mov eax, [hStdOut]
	mov [hCurrentOutput], eax
	
	push dword [ebp-4] ; lpMem
	push dword 0 ; dwFlags
	call _GetProcessHeap@0
	push eax ; hHeap
	call _HeapFree@12
	
	leave
	ret
	
GetConsoleAttributes: ; returns eax = zx(attributes)
	sub esp, 24 ; allocate CONSOLE_SCREEN_BUFFER_INFO
	push esp
	push dword [hCurrentOutput]
	call _GetConsoleScreenBufferInfo@8
	test eax, eax
	jz FatalError
	movzx eax, word [esp+8] ; wAttributes
	add esp, 24 ; free CONSOLE_SCREEN_BUFFER_INFO
	ret
	
ClearConsoleText: ; Clear the consoles text
	push ebp
	mov ebp, esp
	sub esp, 4 ; DWORD charactersWritten-4
	lea eax, [ebp-4] ; LPDWORD
	push eax
	push dword 0 ; coord {0, 0}
	movzx eax, word [screenBufferWidth] 
	movzx ecx, word [screenBufferHeight] 
	mul ecx
	push eax
	push dword ' ' ; cCharacter
	push dword [hCurrentOutput] ; hConsole
	call _FillConsoleOutputCharacterA@20
	test eax, eax
	jz FatalError
	push dword 0 ; coord {0, 0}
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleCursorPosition@8
	leave
	ret 

SetCursorColor: ; bx = colors
	call GetConsoleAttributes
	and ax, ATTRIBUTES_COLOR_CLEAR
	or ax, bx
	push dword eax ; wAttributes
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleTextAttribute@8
	test eax, eax
	jz FatalError
	ret 
	
; --------------- Console Print Functions -------------------

WriteStringPos: ; __stdcall (char* msg[ebp+8], COORD pos[ebp+12])
	push ebp
	mov ebp, esp
	push dword [ebp+12] ; COORD 
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleCursorPosition@8
	test eax, eax
	jz FatalError
	push dword [ebp+8] ; msg
	call WriteString
	pop ebp
	ret 8
	
WriteStringPosLen: ; __stdcall (char* msg[ebp+8], COORD pos[ebp+12], dword len[ebp+16])
	push ebp
	mov ebp, esp
	push dword [ebp+12] ; COORD pos
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleCursorPosition@8 
	push dword [ebp+16] ; len
	push dword [ebp+8]  ; msg
	call WriteStringLen
	pop ebp
	ret 12
	
WriteString: ; __stdcall (char* msg[ebp+8])
	push ebp
	mov ebp, esp
	mov edi, dword [ebp+8] ; msg
	call GetStringLength
	push ecx ; len
	push dword [ebp+8] ; msg
	call WriteStringLen
	pop ebp
	ret 4

WriteStringLen: ; __stdcall (char* msg[ebp+8], dword len[ebp+12])
	push ebp
	mov ebp, esp
	push NULL            ; lpOverlapped
    push NULL            ; lpNumberOfBytesWritten
    push dword [ebp+12]   ; nNumberOfBytesToWrite
    push dword [ebp+8]   ; lpBuffer
    push dword [hCurrentOutput] ; hFile
    call _WriteFile@20
	test eax, eax 
	jz FatalError
	pop ebp
	ret 8
	
WriteChar: ; al = character to write
	mov byte [characterToWrite], al
	push dword 1 ; len
	push characterToWrite ; msg
	call WriteStringLen
	ret
	
WriteDec: ; eax = integer to write
	push edi
	mov edi, (decimalCharactersBufferLength-1)
	
	.write_reminder:
		xor edx, edx
		mov ecx, 10 
		div ecx			; edx = char, eax = quotient
		or dl, 0x30 ; ascii on
		mov byte [decimalCharactersBuffer+edi], dl 
		dec edi
		test eax, eax
		jnz .write_reminder
	
	inc edi
	mov eax, decimalCharactersBufferLength
	sub eax, edi
	push eax ; len
	lea eax, [decimalCharactersBuffer+edi]
	push eax ; msg
	call WriteStringLen
	pop edi
	ret

WriteDecPos: ; eax=integer, edx=position
	push eax
	push edx
	push dword [hCurrentOutput]
	call _SetConsoleCursorPosition@8
	test eax, eax
	jz FatalError
	pop eax
	call WriteDec
	ret
	
WriteCharPos: ; bl = character, eax = position
	push eax ; COORD
	push dword [hCurrentOutput] ; hConsole
	call _SetConsoleCursorPosition@8
	test eax, eax
	jz FatalError
	mov al, bl
	call WriteChar
	ret

Crlf: ; Prints CRLF To the console
	push dword 2
	push dword crlfBuff
	call WriteStringLen
	ret
	
; ----------------- Console Input Functions ---------------

GetKeyCount: ; GetKeyCount();
	sub esp, 4
	push esp ; lpNumberOfEventsRead
	push dword [hStdIn] ; hConsoleHandle
	call _GetNumberOfConsoleInputEvents@8
	test eax, eax
	jz FatalError
	mov eax, dword [esp]
	add esp, 4
	ret

GetKey: ; eax = KeyInput
	push ebp
	mov ebp, esp
	sub esp, 24 ; INPUT_RECORD, DWORD
	

	lea eax, [ebp-4]
	push eax ; lpNumberOfEventsRead
	push dword 1   ; nLength
	lea eax, [ebp-24] 
	push eax ; lpBuffer
	push dword [hStdIn] ;hConsoleInput
	call _ReadConsoleInputA@16
	test eax, eax
	jz FatalError
	cmp word [ebp-24], KEY_EVENT ; loop !(EventType == KEY_EVENT) 
	jnz .not_key
	
	; eax = {
	;   Event.KeyEvent.bKeyDown; 
	;   Event.KeyEvent.wVirtualKeyCode;
	; }
	
	mov ax, word [ebp-14] ; Event.KeyEvent.wVirtualKeyCode
	shl eax, 16 
	cmp dword [ebp-20], 0 ; Event.KeyEvent.bKeyDown
	je .not_key
	mov ax, 1
	leave 
	ret
	

.not_key:
	xor eax, eax
	leave
	ret
	
GetLastKey: ; eax = (has_key) ? vk : 0; 
	call GetKeyCount
	test eax, eax
	jz .return
	push ebx
	mov ebx, eax
	
	.get_next:
		call GetKey
		test ax, ax
		jz .inc_loop
		shr eax, 16
		mov word [lastKeyCode], ax
	.inc_loop:
		dec ebx
		jnz .get_next
	pop ebx
.return:
	movzx eax, word [lastKeyCode]
	ret
	
; ----------------- String Procedures --------------------

GetStringLength: ; edi = string mem, ret ecx length 
	mov ecx, 0xFFFFFFFF
	xor al, al
	repne scasb
	not ecx
	dec ecx
	ret

; ---------------------------------------------------------	