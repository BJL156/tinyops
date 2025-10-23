# TINYOPS

## About
A dump of small assembly programs that can be used for any purpose such as future reference.

## Depedencies
If on Windows install these depedencies in WSL:
- `build-essential`
- `nasm`

## Assembling a Project
With the project cloned via `git clone https://github.com/BJL156/tinyops` follow these steps:
1. Change into the directory of any project. For example:
```
cd x86_64/guessing_game
```
2. In a Linux environment (If on Windows use WSL), run the dedicated makefile for the project:
```
make
```
3. Then run the executable file:
```
./main
```
