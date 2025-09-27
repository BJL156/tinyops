TARGET = main

SRC = $(wildcard *.asm)
OBJ = $(SRC:.asm=.o)

FLAGS = -f elf64

all: $(TARGET)

%.o: %.asm
	nasm $(FLAGS) $< -o $@

$(TARGET): $(OBJ)
	ld $^ -o $@
