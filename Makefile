ASM := nasm 
ASM_FLAGS := -f win32
ASM_DEBUG_FLAGS := $(ASM_FLAGS) -g
LINKER := link 
LIB_PATH := lib
LIBS := lib\kernel32.lib
OBJS := obj\snax86.obj
OBJS_DEBUG := obj\snax86-debug.obj
LINKER_FLAGS := /subsystem:console /nodefaultlib /entry:main /libpath:$(LIB_PATH) /MACHINE:X86
LINKER_DEBUG_FLAGS := $(LINKER_FLAGS) /debug

debug: bin\snax86-debug.exe
release: bin\snax86.exe

bin\snax86.exe: bin_dir obj_dir $(OBJS)
	$(LINKER) $(LINKER_FLAGS) $(OBJS) $(LIBS) /out:$@
	@echo "$@ has been created"

bin\snax86-debug.exe: bin_dir obj_dir $(OBJS_DEBUG)
	$(LINKER) $(LINKER_DEBUG_FLAGS) $(OBJS_DEBUG) $(LIBS) /out:$@
	@echo "$@ has been created"

obj\snax86-debug.obj: src\snax86.asm
	$(ASM) $(ASM_DEBUG_FLAGS) $< -o $@

obj\snax86.obj: src\snax86.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

bin_dir: 
	@mkdir -p bin

obj_dir: 
	@mkdir -p obj

clean:
	rm -rf obj bin

.PHONY: clean debug release bin_dir obj_dir