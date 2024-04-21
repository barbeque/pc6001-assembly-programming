#!/bin/bash

# make a rom
python3 inufuto-builder.py ~/Downloads/aerial.p6
zasm temp_rom.asm
