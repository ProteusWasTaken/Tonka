# Set the project name
TARGET = ./fitGame

# C Compiler and Flags
CC = gcc
cFlags = -O3 -std=c17 -Werror -Wall -Wextra -Wconversion -Winit-self -Wpointer-arith -pedantic -Wuninitialized -Wdouble-promotion -Wstrict-overflow=5 -Wwrite-strings -Waggregate-return -Wcast-qual -Wswitch-default -Wswitch-enum -Wunreachable-code -Wstrict-prototypes -Wcast-align -Wno-unused-parameter -Wno-unused-function -Wno-sign-conversion -g3 -Wfloat-equal -Wundef -Wshadow -Wpointer-arith

# Source Files
srcFiles := main.c

all: $(TARGET)

# Create binary
$(TARGET): $(srcFiles)
	$(CC) $(cFlags) $(srcFiles) -o $(TARGET)
	@tree
	@tokei
	@git status
