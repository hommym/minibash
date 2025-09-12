# Mini-Bash

Mini-Bash is a simple shell implemented in assembly language, demonstrating fundamental operating system interactions and command execution.

## How to Run

To run Mini-Bash, you need to compile the C source files, assemble the assembly files, and then link them together. Follow these steps:

1.  **Compile C source files:**
    ```bash
    gcc -c ui-and-events/eventLoop.c -o eventLoop.o $(pkg-config --cflags sdl2)
    ```
2.  **Assemble assembly files:**
    ```bash
    yasm -f elf64 -g dwarf2 -l main.lst -o minibash.o minibash.asm
    ```
3.  **Link the object files:**
    ```bash
    # This step will require knowing all object files and external libraries.
    # For now, assuming a simple link, but this might need adjustment.
    ld minibash.o eventLoop.o -o minibash -lSDL2 -lc
    ```
4.  **Execute Mini-Bash:**
    ```bash
    ./minibash
    ```

## Main Features

- **Command Execution**: Run external programs found in `/usr/bin`.
- **Built-in `cd` command**: Change the current working directory.
- **Built-in `clear` command**: Clear the terminal screen.
- **Current Working Directory Display**: The shell prompt displays the current working directory.
- **Basic Input Handling**: Reads single characters and builds command strings.

## Work in Progress

We are currently working on improving the robustness and functionality of Mini-Bash. Specific areas of focus include:
- **Command History Navigation**: Implementing functionality to navigate through previously entered commands (e.g., using arrow keys).
- **PATH Resolution**: Implementing a more flexible command resolution mechanism, similar to how standard shells use the `PATH` environment variable.
- **Code Refactoring**: Restructuring the assembly code for better readability, maintainability, and efficiency. This includes introducing constants, macros, and safer helper functions.
- **Enhanced Command Parsing**: Implementing more robust argument parsing, including support for multiple arguments and quoted strings.
- **Error Handling**: Improving error messages and handling of various command execution failures.
- **Memory Management**: Ensuring safe memory operations and preventing buffer overflows.


Feel free to explore the `main.asm` file to understand the inner workings of this minimalistic shell.
