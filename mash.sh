#!/bin/bash

# make a rom
python3 inufuto-builder.py ~/Downloads/lift.p6
zasm temp_rom.asm
