# 6502-practice
A collection of micro-projects dedicated to learning 6502 assembly language and its application in Atari 2600 game development. Many of these demos are based off of examples from a [6502 Assembly Language Atari 2600 tutorial series](https://www.randomterrain.com/atari-2600-memories-tutorial-andrew-davie-01.html) and some other resources from the **[Reading Material](#reading-material)** section.

## Usage

### Compile and Use Binaries

1. Install the [DASM](https://dasm-assembler.github.io/) assembler in order to compile the `.asm` source files
2. Copy the `vcs.h` and `macro.h` files that come with DASM for the Atari 2600 into the `lib` directory
3. Enter one of the project directories
4. Perform the command:

    `$ sh compile.sh`

5. Enter the bin folder that was created
6. Use the `.bin` file in your Atari 2600 emulator of choice

## Contributing
If you have any changes in mind or improvements that you would like to see, feel free to contribute to this project.

Here are the following steps you should take to contribute to this project:
 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that your changes can be reviewed

> Be sure to merge the latest from "upstream" before making a pull request!

## Reading Material

[Learn 6502 Assembly Language](https://skilldrick.github.io/easy6502/)
> An interactive introduction to assembly language using 6502 assembly.

[6502 Assembly Language Instruction Reference](http://www.obelisk.me.uk/6502/reference.html)
> This is my go-to instruction set reference

[6502 Assembly Language and Atari 2600 Development Tutorial Series](https://www.randomterrain.com/atari-2600-memories-tutorial-andrew-davie-01.html)
> This is a comprehensive, beginner friendly tutorial for 6502 Assembly Language Atari 2600 development.

[Atari 2600 Game Development Tutorial Series](https://www.randomterrain.com/atari-2600-lets-make-a-game-spiceware-00.html)
> This tutorial builds off of the knowledge acquired from a [previously mentioned tutorial series](https://www.randomterrain.com/atari-2600-memories-tutorial-andrew-davie-01.html). In this tutorial series you can find best practices and pragmatic solutions to challenging Atari 2600 constraints.
