# Mini-Bash

Mini-Bash is a simple shell implemented in assembly language, demonstrating fundamental operating system interactions and command execution.

## How to Run

To run Mini-Bash, you need to assemble and link the `main.asm` file. Assuming you have `nasm` (Netwide Assembler) and `ld` (GNU Linker) installed, follow these steps:

1.  **Assemble the source code:**
    ```bash
    nasm -f elf64 main.asm -o main.o
    ```
2.  **Link the object file:**
    ```bash
    ld main.o -o main
    ```
3.  **Execute Mini-Bash:**
    ```bash
    ./main
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
