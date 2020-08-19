<a id=top></a>

# z80asm - Z80 module assembler, linker, librarian

**z80asm** is part of the [z88dk](http://www.z88dk.org/) project and is used as the back-end of the z88dk C compilers. It is not to be confused with other non-**z88dk** related projects with the same name.

**z80asm** is a relocatable assembler, linker and librarian that can assemble Intel 8080/8085 and Z80-family assembly files into a relocatable object format, can manage sets of object files in libraries and can build binary images by linking these object files together. The binary images can be defined in different sections, to match the target architecture.

**NOTE**: This document is a work-in-progress. It describes the functionality already working in the assembler in the **z80asm2** branch. This document and the `z80asm-future.md` will converge as **z80asm2** gets more features and converges to the current capability of **z80asm** in the **master** branch.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1></a>

## 1. Usage ...


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_1></a>

### 1.1. ... as assembler

    z80asm [options] file...

By default, i.e. without any options, assemble each of the listed files into relocatable object files with a `.o` extension. 


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_2></a>

### 1.2. ... as linker

    z80asm -b [options] [-llibrary.lib...] file...

Link the object files together and with any requested libraries into a set of binary files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_3></a>

### 1.3. ... as librarian

    z80asm -xlibrary.lib [options] file...

Build a library containing all the object files passed as argument. That library can then be used during linking by specifying it with the `-l` option.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=2></a>

## 2. Environment Variables

The syntax `${ENV_VAR}` can be used whenever a file name or a command line option is expected, and expands to the value of the given environment variable, or the empty string if it is not defined.

The environment variable `Z80ASM`, if defined, contains additional options that are used in every invocation of **z80asm**.

The environment variable `ZCCCFG` is used to search for the **z80asm** libraries at its parent directory, i.e. `${ZCCCFG}/..`. These libraries define emulation routines for certain opcodes not available in all platforms. 

**TODO**: table with all emulated opcodes.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3></a>

## 3. Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_1></a>

### 3.1. Help Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_1_1></a>

#### 3.1.1. no arguments (show usage)

Show a help screen with the available options. 


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_1_2></a>

#### 3.1.2. -h, -? (show manual)

Show this document. The output can be piped to `more` for pagination.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_1_3></a>

#### 3.1.3. -v (show progress)

Show progress messages on `stdout`.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2></a>

### 3.2. Environment Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_1></a>

#### 3.2.1. -IDIR (directory for source files)

Append the specified directory to the search path for source and include files.

While each source file is being assembled, its parent directory is automatically added to the search path, so that `INCLUDE` can refer to include files via a relative path to the source.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_2></a>

#### 3.2.2. -LDIR (directory for library)

Append the specified directory to the search path for library files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_3></a>

### 3.3. -DVAR[=num] (define a static symbol)

Define the given variable as a static symbol with the given value, or 1 if not supplied.

The value can be written in decimal (e.g. -Dvar=255) or hexadecimal (e.g. -Dvar=0xff or -Dvar=0ffh or -Dvar=$ff). Note that the '$' may need to be escaped from the shell.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4></a>

### 3.4. Code Generation Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4_1></a>

#### 3.4.1. -mCPU (select CPU)

Assemble for the given CPU. The following CPU's are supported:

| CPU      | Name                          |
| -------- | ----------------------------- |
| z80      | Zilog Z80                     |
| z180     | Zilog Z180                    |
| z80n     | ZX Next variant of the Z80    |
| gbz80    | GameBoy variant of the Z80    |
| 8080     | Intel 8080 (1)                |
| 8085     | Intel 8085 (1)                |
| r2k      | Rabbit RCM2000                |
| r3k      | Rabbit RCM3000                |
| ti83     | Texas Instruments TI83 (2)    |
| ti83plus | Texas Instruments TI83Plus (2)|

**Notes:**

**(1)** The Intel 8080 and 8085 are with Zilog or Intel mnemonics, except for the mnemonics that have different meanings, i.e.

| Intel | Zilog      | Comment                                     |
| ----- | ---------- | ------------------------------------------- |
| JP nn | JP P, nn   | Must use Zilog mnemonic, as JP is ambiguous |
| CP nn | CALL P, nn | Must use Zilog mnemonic, as CP is ambiguous |

**(2)** The Texas Instruments CPU's are standard Z80, but the `INVOKE` statement is assembled differently, i.e.

| CPU      | Statement | Assembled as       |
| ----     | --------- | ------------------ |
| ti83     | INVOKE nn | CALL nn            |
| ti83plus | INVOKE nn | RST 0x28 \ DEFW nn |


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4_2></a>

#### 3.4.2. -IXIY (swap IX and IY)

Swap all occurrences of registers `IX` and `IY`, and also their 8-bit halves (`IXH`, `IXL`, `IYH` and `IYL`).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4_3></a>

#### 3.4.3. -opt-speed (optimise for speed)

Replace all occurrences of `JR` by `JP`, as the later are faster. `DJNZ` is not replaced by `DEC B \ JP` as the later is slower.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4_4></a>

#### 3.4.4. -debug (debug information)

Add debug information to the map file: new symbols `__C_LINE_nn` and `__ASM_LINE_nn` are created on each `C_LINE` statement (supplied by the C compiler) and each asm line, and listed in the map file together with their source file location.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_5></a>

### 3.5. Output File Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_5_1></a>

#### 3.5.1. -s (create symbol table)

Creates a symbol table `file.sym` at the end of the assembly phase, containing all the symbols from the assembled file. The format of the file is the same as the map file (see ` [-m](#3_5_3) `).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_5_2></a>

#### 3.5.2. -l (create list file)

Creates a symbol table `file.lis` containing the source code parsed and the corresponding generated object code. The list file is created during assembly, i.e. before linking, and therefore all addresses that will be resolved by the linker are shown as zero in the list file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_5_3></a>

#### 3.5.3. -m (create map file)

Creates a map file `file.map` at the end of the link phase. The map file contains one line per defined symbol, with the following information:

  - symbol name
  - '='
  - aboslute address in the binary file in hexadecimal
  - ';'
  - 'const' if symbols is a constant, 'addr' if it is an address or 'comput' if it is an expression evaluated at link time
  - ','
  - scope of the symbol: 'local', 'public', 'extern' or 'global'
  - ','
  - 'def' if symbol is a global define (defined with `-Dsymbol` or `DEFINE`), empty string otherwise
  - ','
  - module name where symbol was defined
  - ','
  - section name where symbol was defined
  - ','
  - source file name where symbol was defined
  - ':'
  - source line number where symbol was defined
  

----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_5_4></a>

#### 3.5.4. -g (global definitions file)

Creates an assembly include file `file.def` containing the values of all the global symbols after linking in the form of `DEFC` statements. This file can be included in another assembly source file to uses these symbols.







----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4></a>

## 4. Copyright

The original z80asm module assembler was written by Gunther Strube. 
It was converted from QL SuperBASIC version 0.956, initially ported to Lattice C,
and then to C68 on QDOS.

It has been maintained since 2011 by Paulo Custodio.

Copyright (C) Gunther Strube, InterLogic 1993-99  
Copyright (C) Paulo Custodio, 2011-2020


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=5></a>

## 5. License

Artistic License 2.0 (http://www.perlfoundation.org/artisticlicense2_0)

<a id=keywords></a>


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6></a>

## 6. Keywords
 [-DVAR](#3_3) 
 [-IDIR](#3_2_1) 
 [-IXIY](#3_4_2) 
 [-LDIR](#3_2_2) 
 [-debug](#3_4_4) 
 [-g](#3_5_4) 
 [-h](#3_1_2) 
 [-l](#3_5_2) 
 [-m](#3_5_3) 
 [-mCPU](#3_4_1) 
 [-opt](#3_4_3) 
 [-s](#3_5_1) 
 [-v](#3_1_3) 
<a id=index></a>


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7></a>

## 7. Index
- [1.](#1) Usage ...
  - [1.1.](#1_1) ... as assembler
  - [1.2.](#1_2) ... as linker
  - [1.3.](#1_3) ... as librarian
- [2.](#2) Environment Variables
- [3.](#3) Options
  - [3.1.](#3_1) Help Options
    - [3.1.1.](#3_1_1) no arguments (show usage)
    - [3.1.2.](#3_1_2)  [-h](#3_1_2) , -? (show manual)
    - [3.1.3.](#3_1_3)  [-v](#3_1_3)  (show progress)
  - [3.2.](#3_2) Environment Options
    - [3.2.1.](#3_2_1)  [-IDIR](#3_2_1)  (directory for source files)
    - [3.2.2.](#3_2_2)  [-LDIR](#3_2_2)  (directory for library)
  - [3.3.](#3_3)  [-DVAR](#3_3) [=num] (define a static symbol)
  - [3.4.](#3_4) Code Generation Options
    - [3.4.1.](#3_4_1)  [-mCPU](#3_4_1)  (select CPU)
    - [3.4.2.](#3_4_2)  [-IXIY](#3_4_2)  (swap IX and IY)
    - [3.4.3.](#3_4_3)  [-opt](#3_4_3) -speed (optimise for speed)
    - [3.4.4.](#3_4_4)  [-debug](#3_4_4)  (debug information)
  - [3.5.](#3_5) Output File Options
    - [3.5.1.](#3_5_1)  [-s](#3_5_1)  (create symbol table)
    - [3.5.2.](#3_5_2)  [-l](#3_5_2)  (create list file)
    - [3.5.3.](#3_5_3)  [-m](#3_5_3)  (create map file)
    - [3.5.4.](#3_5_4)  [-g](#3_5_4)  (global definitions file)
- [4.](#4) Copyright
- [5.](#5) License
- [6.](#6) Keywords
- [7.](#7) Index