MAME = /Users/mike/mame0253-arm64/mame
mame_dir = $(dir $(MAME))
local_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
mame_args = -skip_gameinfo -window # -aviwrite pc6001.avi
asm_args = -w
asm = zasm

pc6001.bin: pc6001.asm 
	$(asm) $(asm_args) pc6001.asm -o pc6001.bin

all: pc6001.bin 

clean:
	rm -f pc6001.bin pc6001.lst

run: pc6001.bin
	cd $(mame_dir) && $(MAME) pc6001 $(mame_args) -cart1 $(local_path)pc6001.bin

debug: pc6001.bin
	cd $(mame_dir) && $(MAME) pc6001 $(mame_args) -debug -cart1 $(local_path)pc6001.bin

flash: pc6001.bin
	python3 ./utilities/prepare.py -s 256 pc6001.bin
	minipro -p W27C257@DIP28 -s -w pc6001.padded.bin

openshots:
	open $(mame_dir)/snap/pc6001
