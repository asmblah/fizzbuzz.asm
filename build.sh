#/usr/bin/env sh

# Clean up
rm -f ./fizzbuzz

# Compile
nasm -f macho fizzbuzz.asm

# Link
ld -o fizzbuzz -e start fizzbuzz.o
