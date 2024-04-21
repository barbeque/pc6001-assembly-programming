#!/bin/bash

# make a rom
python3 inufuto-builder.py ~/Downloads/battlot.p6
zasm temp_rom.asm
