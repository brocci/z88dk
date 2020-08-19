<a id=top></a>

# z80asm - Z80 module assembler, linker, librarian

**z80asm** is part of the [z88dk](http://www.z88dk.org/) project and is used as the back-end of the z88dk C compilers. It is not to be confused with other non-**z88dk** related projects with the same name.

**z80asm** is a relocatable assembler, linker and librarian that can assemble Intel 8080/8085 and  [Z80](#7) -family assembly files into a relocatable object format, can manage sets of object files in libraries and can build binary images by linking these object files together. The binary images can be defined in different sections, to match the target architecture.




----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1></a>

## 1. Usage ...


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_1></a>

### 1.1. ... as preprocessor

    z80asm -E [options] file...

Preprocess each input file and store the result in files with the `.i` extension, with all macros expanded, include files expanded, and constants converted to hexadecimal. 


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_2></a>

### 1.2. ... as assembler

    z80asm [options] file...

By default, i.e. without any options, assemble each of the listed files into relocatable object files with a `.o` extension. 


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_3></a>

### 1.3. ... as linker

    z80asm  [-b](#6_2_4)  [options] [-ilibrary.lib...] file...

Link the object files together and with any requested libraries into a set of binary files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=1_4></a>

### 1.4. ... as librarian

    z80asm -xlibrary.lib [options] file...

Build a library containing all the object files passed as argument. That library can then be used during linking by specifying it with the ` [-i](#6_2_10) ` option.


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

### 3.2. Preprocessor options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_1></a>

#### 3.2.1. -atoctal (at is octal prefix)

By default the at-character (`@`) is used as a binary number prefix. 

With the option ` [-atoctal](#3_2_1) ` it is used as the octal number prefix instead.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_2></a>

#### 3.2.2. -dotdirective (period is directive prefix)

By default the period (`.`) is used to signal that the next identifier is a label. 

With the option ` [-dotdirective](#3_2_2) ` it is used instead to signal that the next identifier is an assembler directive.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_3></a>

#### 3.2.3. -hashhex (hash is hex prefix)

By default the hash-character (`#`) is used to signal that the next expression should be compiled as an immediate value. This meaning, although common in assemblers, is a no-operation in **z80asm**. 

With the option ` [-hashhex](#3_2_3) ` the hash-character is used as the hexadecimal number prefix instead.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_4></a>

#### 3.2.4. -labelcol1 (labels at column 1)

By default **z80asm** needs either a period (`.`) prefix (but see ` [-dotdirective](#3_2_2) `) or a colon (`:`) suffix to signal that an identifier is a label, and white space at the beginning of a line is not significant.

With the option ` [-labelcol1](#3_2_4) ` an identifier is a label if started at column 1, or a directive or opcode if started after white space.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_2_5></a>

#### 3.2.5. -ucase (upper case)

By default **z80asm** is case-sensitive for identifiers, but case-insensitive for assembly keywords (opcodes, directives, registers and flags).

The option ` [-ucase](#3_2_5) ` causes **z80asm** to convert all the symbols to upper-case, so that code that assumes case-insensitivity can be assembled.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_3></a>

### 3.3. Assembly options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_3_1></a>

#### 3.3.1. -noprec (no precedence in expression evaluation)

By default **z80asm** follows the C-precedence rules while evaluating expressions:

| Precedence | Operators  | Description                              | Associativity |
| ---       | ---        | ---                                      | ---           |
| 1         | **         | Power                                    | right-to-left |
| 2         | + - #      | Unary plus, unary minus, immediate       | right-to-left |
| 3         | ! ~        | Logical NOT and bitwise NOT              | right-to-left |
| 4         | * / %      | Multiply, divide and remainder           | left-to-right |
| 5         | + -        | Add and subtract                         | left-to-right |
| 6         | << >>      | Bitwise left-shift and right-shift       | left-to-right |
| 7         | < <= > >=  | Less, Less-equal, greater, greater-equal | left-to-right |
| 8         | = == != <> | Equal (two forms), Not equal (two forms) | left-to-right |
| 9         | &          | Bitwise AND                              | left-to-right |
| 10        | ^          | Bitwise XOR                              | left-to-right |
| 11        | \|         | Bitwise OR                               | left-to-right |
| 12        | &&         | Logical AND                              | left-to-right |
| 13        | ^^         | Logical XOR                              | left-to-right |
| 14        | \|\|       | Logical OR                               | left-to-right |
| 15        | ?:         | Ternary conditional                      | right-to-left |

With the ` [-noprec](#3_3_1) ` expressions are evaluated strictly left-to-right.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4></a>

### 3.4. Environment Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4_1></a>

#### 3.4.1. -IDIR (directory for source files)

Append the specified directory to the search path for source and include files.

While each source file is being assembled, its parent directory is automatically added to the search path, so that ` [INCLUDE](#10_18) ` can refer to include files via a relative path to the source.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_4_2></a>

#### 3.4.2. -LDIR (directory for library)

Append the specified directory to the search path for library files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_5></a>

### 3.5. -DVARIABLE [= value], --define=VARIABLE [= value] (define a static symbol)

Define the given variable as a static symbol with the given value, or 1 if not supplied.

The value can be written in decimal (e.g. -Dvar=255) or hexadecimal (e.g. -Dvar=0xff or -Dvar=0ffh or -Dvar=$ff). Note that the '$' may need to be escaped from the shell.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_6></a>

### 3.6. Code Generation Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_6_1></a>

#### 3.6.1. -mCPU (select CPU)

Assemble for the given CPU. The following CPU's are supported:

| CPU      | Name                          |
| -------- | ----------------------------- |
| z80      | Zilog  [Z80](#7)                      |
| z180     | Zilog Z180                    |
| z80n     | ZX Next variant of the  [Z80](#7)     |
| gbz80    | GameBoy variant of the  [Z80](#7)     |
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
| CP nn |  [CALL](#10_2)  P, nn | Must use Zilog mnemonic, as CP is ambiguous |

**(2)** The Texas Instruments CPU's are standard  [Z80](#7) , but the ` [INVOKE](#10_19) ` statement is assembled differently, i.e.

| CPU      | Statement | Assembled as       |
| ----     | --------- | ------------------ |
| ti83     |  [INVOKE](#10_19)  nn |  [CALL](#10_2)  nn            |
| ti83plus |  [INVOKE](#10_19)  nn | RST 0x28 \  [DEFW](#10_4)  nn |


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_6_2></a>

#### 3.6.2. -IXIY (swap IX and IY)

Swap all occurrences of registers `IX` and `IY`, and also their 8-bit halves (`IXH`, `IXL`, `IYH` and `IYL`).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_6_3></a>

#### 3.6.3. -opt-speed (optimise for speed)

Replace all occurrences of `JR` by `JP`, as the later are faster. `DJNZ` is not replaced by `DEC B \ JP` as the later is slower.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_6_4></a>

#### 3.6.4. -debug (debug information)

Add debug information to the map file: new symbols `__C_LINE_nn` and `__ASM_LINE_nn` are created on each `C_LINE` statement (supplied by the C compiler) and each asm line, and listed in the map file together with their source file location.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_7></a>

### 3.7. Output File Options


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_7_1></a>

#### 3.7.1. -s (create symbol table)

Creates a symbol table `file.sym` at the end of the assembly phase, containing all the symbols from the assembled file. The format of the file is the same as the map file (see ` [-m](#3_7_3) `).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_7_2></a>

#### 3.7.2. -l (create list file)

Creates a symbol table `file.lis` containing the source code parsed and the corresponding generated object code. The list file is created during assembly, i.e. before linking, and therefore all addresses that will be resolved by the linker are shown as zero in the list file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=3_7_3></a>

#### 3.7.3. -m (create map file)

Creates a map file `file.map` at the end of the link phase. The map file contains one line per defined symbol, with the following information:

  - symbol name
  - '='
  - aboslute address in the binary file in hexadecimal
  - ';'
  - 'const' if symbols is a constant, 'addr' if it is an address or 'comput' if it is an expression evaluated at link time
  - ','
  - scope of the symbol: 'local', 'public', 'extern' or 'global'
  - ','
  - 'def' if symbol is a global define (defined with `-Dsymbol` or ` [DEFINE](#10_9) `), empty string otherwise
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
<a id=3_7_4></a>

#### 3.7.4. -g (global definitions file)

Creates an assembly include file `file.def` containing the values of all the global symbols after linking in the form of ` [DEFC](#10_6) ` statements. This file can be included in another assembly source file to uses these symbols.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4></a>

## 4. Input Files

**z80asm** reads text files in the syntax supported by the specific processor being assembled for (see ` [-mCPU](#3_6_1) ` option) and produces the corresponding object files.

An input file with a `.o` extension is assumed to be already in object file format and is just read by the linker. Any other extension is considered an assembly source file (conventionally `.asm`).

A project list file may be supplied in the command line prefixed by the at-sign (e.g. `@project.lst`). The list file contains one input file name per line, or another project list prefixed with an at-sign, which is opened recursively. Hash signs (`#`) and semi-colons (`;`) may be used at the start of lines in the list files to include comments.

Both the command line and the list files support wild-cards to expand all the files that match the given pattern.

**Note** that the Operating System may do its own wildcard expansion and the pattern may need to be quoted in the command line.

A single star in a file name (`*`) expands to the list of all files/directories that match the complete pattern, where the star represents any sequence of characters. A double-star in a directory name (`**`) expands to the complete directory sub-tree, when searched recursively.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_1></a>

### 4.1. Source File Format

The assembler parses source files with any of the common end-of-line termination sequences (`"\r"`, `"\n"` or `"\r\n"`). Each line starts with an optional label and can contain assembly directives (i.e. instructions to the assembler), assembly instructions (i.e. code to be translated into object code for the specific processor) or blanks and comments.

A single backslash character (`\`) may be used to separate multiple statements in a single line.

    org 0                     ; assembly directive  
    start: push bc\pop hl     ; define a label and add two assembly opcodes              
    ret                       ; assembly opcode can be at the first column    

Differently to most other assemblers, white space is not significant, i.e. a label can be defined after white space, and an opcode can be written at column 1 (but see option ` [-labelcol1](#3_2_4) `).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_2></a>

### 4.2. Comments

Comments may start with a semi-colon (`;`) or two slashes (`//`) and end at the end of the line, or may start with slash-star (`/*`) and end with star-slash (`*/`), possibly spanning multiple lines.

    ld a, 1                   ; this is a comment
    ld b, 2                   // another comment
    ld c, /* multi-line comment is valid
             in the middle of an instruction 
          */ 3                ; C = 3


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_3></a>

### 4.3. Symbols

All symbols in the code (labels, variables, ...) are named with unique identifiers. Identifiers start with a letter or underscore (`_`), and can contain letters, digits, underscores or periods (`.`). Identifiers are case-sensitive (but see option ` [-ucase](#3_2_5) `).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_4></a>

### 4.4. Labels

A label is a symbol that represents the current assembly address (`ASMPC`) and is defined at the start of a line by prefixing a symbol with a period (`.`) (but see ` [-dotdirective](#3_2_2) `) or suffixing it with a colon (`:`), i.e. either `.label` or `label:` (but see ` [-labelcol1](#3_2_4) `).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_5></a>

### 4.5. Numbers

The assembler accepts numbers in decimal, hexadecimal, octal and binary. Different syntaxes are allowed to simplify porting code written for other assemblers. Some of the prefix characters are also used as operators; in this case a space may be needed to signal the difference, e.g.

    ld a, %10     ; A = 2 (10 binary)
    ld a, 12 % 10 ; A = 2 (remainder of 12 divided by 10)

All expressions are computed as signed integers with the host platform's integer size (32-bit or 64-bit in the most common platforms). Expression evaluation follows the operator precedence of C (but see ` [-noprec](#3_3_1) `).

The underscore can be used to separate groups of digits to help readability, e.g. `0xFFFF_FFFF` is the same as `0xFFFFFFFF`.

Floating point numbers can be supplied with the `FLOAT` directive, that encodes them in the current floating point format in the object code. Floating point numbers must be supplied in decimal base and have an integer part and a fractional part separated by a period, followed by an optional `e` (exponent), a plus or minus sign, and the power of 10 to multiply to the base.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_5_1></a>

#### 4.5.1. Decimal

Decimal numbers are a sequence of decimal digits (`0..9`), optionally followed by a `d` or `D` - all prefixes and suffixes are case-insensitive. Leading zeros are insignificant - note the difference from C, where a leading zero means octal.

    ld a, 99
    ld a, 99d


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_5_2></a>

#### 4.5.2. Hexadecimal

Hexadecimal numbers are a sequence of hexadecimal digits (`0..9` and `A..F`, case-insensitive), either prefixed or suffixed with an hexadecimal marker. If the marker is a suffix, and the number starts with a letter, then a leading zero has to be added.

The hexadecimal prefix `$` is also the `ASMPC` identifier if not followed by a hexadecimal number, i.e. the address of the instruction being assembled.

The hexadecimal prefix `#` is only recognised with the option ` [-hashhex](#3_2_3) `.

    ld a, $FF
    ld a, #FF           ; only with option  [-hashhex](#3_2_3) 
    ld a, 0xFF
    ld a, 0FFh


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_5_3></a>

#### 4.5.3. Octal

Octal numbers are a sequence of octal digits (`0..7`), either prefixed or suffixed with an octal marker. 

The octal-prefix `@` is only recognised with the option ` [-atoctal](#3_2_1) `.

    ld a, @77           ; only with option  [-atoctal](#3_2_1) 
    ld a, 0o77
    ld a, 0q77
    ld a, 77o
    ld a, 77q


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_5_4></a>

#### 4.5.4. Binary

Binary numbers are a sequence of binary digits (`0..1`), either prefixed or suffixed with a binary marker.  

The binary prefix `%` is also the modulus operator, if not followed by a binary digit. 

The binary prefix `@` is recognised unless the option ` [-atoctal](#3_2_1) ` is given.

    ld a, %11
    ld a, @11           ; except with option  [-atoctal](#3_2_1) 
    ld a, 0b11
    ld a, 11b


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_5_5></a>

#### 4.5.5. Bitmaps

Binary numbers can be specified as bitmaps, with `#` as `1` and `-` as `0`, using the binary prefix (`@` or `%`) immediately followed by a double-quoted string of hashes and dashes.

    defb @"---##---"
    defb @"-##--##-"
    defb %"-##-----"
    defb %"-##-----"
    defb @"-##--##-"
    defb @"---##---"



----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_6></a>

### 4.6. Keywords

Processor registers (`BC`, `DE`, ...) and flags (`NZ`, `Z`, ...), and assembly `ASMPC`, representing the current assembly location, are reserved keywords. They cannot be used as identifiers, and are case-insensitive.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=4_7></a>

### 4.7. Directives and Opcodes

Assembler directives (` [ORG](#10_25) `, ` [INCLUDE](#10_18) `, ...) and processor opcodes (`NOP`, `LD`, ...) are interpreted as directives or opcodes when appearing at the start of the statement or after a label definition, or as regular identifiers otherwise. The directives and opcodes are case-insensitive.

    jr: jr jr  ; silly example, jr is both a label and an opcode
               ; while correct code, it's confusing, don't do it


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=5></a>

## 5. Object File Format

The object and library files are stored in binary form as a set of contiguous sections. The files are cross-platform compatible, i.e. they can be created in a big-endian architecture and used in a little-endian one. 

The files start with a signature and a version number.

A set of file pointers at the start of the object file point to the start of each section existing the in the file, or contain *0xFFFFFFFF* (-1) if that section does not exist.

The following object types exist in the file:

| Type      | Size (bytes)  | Description                                       |
| ---       | ---           | ---                                               |
| *char*    | 1             | ASCII character                                   |
| *byte*    | 1             | unsigned 8-bit value                              |
| *word*    | 2             | unsigned 16-bit value, little-endian ( [Z80](#7) /Intel)  |
| *dword*   | 4             | signed 32-bit value, little-endian ( [Z80](#7) /Intel)    |
| *string*  | 1+length      | one byte with the string length followed by the characters of the string |
| *lstring* | 2+length      | one word with the string length followed by the characters of the string |


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=5_1></a>

### 5.1. Object Files

The format of the object files is as follows:

| Addr  | Type      | Value     | Description
| ---   | ---       | ---       | ---
|   0   | char[8]   | "Z80RMF14"| File signature and version
|   8   | dword     | pmodule   | File pointer to *Module Name*, always the last section
|  12   | dword     | pexpr     | File pointer to *Expressions*, may be -1
|  16   | dword     | pnames    | File pointer to *Defined Symbols*, may be -1
|  20   | dword     | pextern   | File pointer to *External Symbols*, may be -1
|  24   | dword     | pcode     | File pointer to *Code Sections*, may be -1
| pexpr |           |           | *Expressions*: set of expressions up to end marker
|       | char      | type      | Type of expression
|       |           |  0        | end marker 
|       |           | 'U'       | 8-bit integer (0 to 255)  
|       |           | 'S'       | 8-bit signed integer (-128 to 127)  
|       |           | 'u'       | 8-bit integer (0 to 255) extended to 16 bits
|       |           | 's'       | 8-bit signed integer (-128 to 127) sign-extended to 16 bits
|       |           | 'C'       | 16-bit integer, little-endian (-32768 to 65535)  
|       |           | 'B'       | 16-bit integer, big-endian (-32768 to 65535)  
|       |           | 'P'       | 24-bit signed integer     
|       |           | 'L'       | 32-bit signed integer     
|       |           | 'J'       | 8-bit jump relative offset
|       |           | '='       | Computed name at link time   
|       | lstring   | sourcefile| Source file name of expression definition, empty to reuse same from previous expression
|       | dword     | linenumber| Line number in source file of expression definition
|       | string    | section   | Section name of expression definition 
|       | word      | ASMPC     | Relative module code address of the start of the assembly instruction to be used as *ASMPC* during expression evaluation
|       | word      | patchptr  | Relative module code patch pointer to store the result of evaluating the expression
|       | string    | targetname| Name of the symbol that receives the result of evaluating the expression, only used for '=' type expressions, empty string for the other types
|       | lstring   | expression| Expression text as parsed from the source file
|       |           |           | ... repeat for every expression ...
| pnames|           |           | *Defined Symbols*: set of defined symbols up to end marker
|       | char      | scope     | Scope of the symbol:
|       |           |  0        | end marker
|       |           | 'L'       | is local
|       |           | 'G'       | is global
|       | char      | type      | Type of symbol: 
|       |           | 'A'       | Relocatable address   
|       |           | 'C'       | Constant
|       |           | '='       | Symbol computed at link time, the corresponding expression is in the *Expressions* section
|       | string    | section   | Section name of symbol definition 
|       | dword     | value     | Absolute value for a constant, or the relative address to the start of the code block for a relocatable address
|       | string    | name      | Name of symbol
|       | string    | sourcefile| Source file name of symbol definition
|       | dword     | linenumber| Line number in source file of symbol definition
|       |           |           | ... repeat for every symbol ...
|pextern|           |           | *External Symbols*: set of external symbols referred in the module, up *Module Name*
|       | string    | name      | Name of external symbol
|       |           |           | ... repeat for every symbol ...
|pmodule| string    | modname   | *Module Name*: Name of the module
| pcode |           |           | *Code Sections*: set of sections of binary code, up to end marker
|       | dword     | length    | Code length, -1 to signal the end
|       | string    | section   | Section name of code
|       | dword     | origin    | User defined  [ORG](#10_25)  address for the start of this section, -1 for no  [ORG](#10_25)  address was defined, or -2 to split section to a different binary file. If multiple sections are given with an  [ORG](#10_25)  address each, the assembler generates one binary file for each section with a defined  [ORG](#10_25) , followed by all sections without one.
|       | dword     | align     | Address alignment of this section, -1 if not defined. The previous section is padded to align the start address of this section.
|       |byte[length]|code      | Binary code
|       |           |           | ... repeat for every section ...


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=5_2></a>

### 5.2. Library File Format

The library file format is a sequence of object files with additional
structures.

| Addr  | Type      | Value     | Description
| ---   | ---       | ---       | ---
|   0   | char[8]   | "Z80LMF14"| File signature and version
| obj   |           |           | *Object File Block*, repeats for every object module
|       | dword     | next      | File pointer of the next object file in the library, -1 if this is the last one
|       | dword     | length    | Length of this object file, or 0 if this object files has been marked "deleted" and will not be used
|       |byte[length]| obj      | Object file
|       |           |           | ... repeat for every object file ...


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=5_3></a>

### 5.3. Format History

| Version   | Comment
| ---       | ---
| 01        | original z80asm version
| 02        | allow expressions to use standard C operators instead of the original (legacy) z80asm specific syntax. 
| 03        | include the address of the start of the assembly instruction in the object file, so that expressions with ASMPC are correctly computed at link time; remove type 'X' symbols (global library), no longer used.
| 04        | include the source file location of expressions in order to give meaningful link-time error messages.
| 05        | include source code sections.
| 06        | incomplete implementation, fixed in version *07*
| 07        | include  [DEFC](#10_6)  symbols that are defined as an expression using other symbols and are computed at link time, after all addresses are allocated.
| 08        | include a user defined  [ORG](#10_25)  address per section.
| 09        | include the file and line number where each symbol was defined.
| 10        | allow a section alignment to be defined.
| 11        | allow big-endian 16-bit expressions to be patched; these big-endian values are used in the ZXN coper unit.
| 12        | allow the target expression of relative jumps to be computed in the link phase
| 13        | add 8-bit signed and unsigned values extended to 16-bits
| 14        | add 24-bit pointers


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6></a>

## 6. z80asm Syntax

THE  [Z80](#7)  CROSS ASSEMBLER (z88dk)
===============================

Version: v2.6.1 (October 3rd, 2014)

Thank you for purchasing a copy of this cross assembler. We have made an effort to program an easy user interface and efficient assembler source file compiling. The object file and library format is an invention of our own and has also been included in this documentation. We hope that you will enjoy your  [Z80](#7)  machine code programming with our assembler.

We have made an effort to produce a fairly easy-to-understand documentation. If you have any comments or corrections, please don't hesitate to contact us:

Gunther Strube  
Gl. Kongevej 37, 4.tv.  
DK-1610 Kobenhavn V  
Denmark  
e-mail [gbs@image.dk](mailto:gbs@image.dk)

1\. Running the assembler
-------------------------


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_1></a>

### 6.1. Command line

The syntax of the assembler parameters is a straightforward design. Filenames or a project file are always specified. The options may be left out:

    z80asm [options] <filename {filename}> | <@modulesfile>

As seen above \<options\> must be specified first. Then you enter the names of all files to be assembled. You either choose to specify all file names or a @\<project-file\> containing all file names. File name may be specified with or without the 'asm extension. The correct filename parsing is handled automatically by the assembler. As seen on the syntax at least one source file must be specified and may be repeated with several file names. Only one project file may be specified if no source file names are given.

Many of the parameters are preset with default values which gives an easy user interface when specifying the assembly parameters. Only advanced parameters need to be specified explicitly. The help page displays the default parameter values at the bottom of the page.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2></a>

### 6.2. Command line options

Options are used to control the assembly process and output. They are recognised by the assembler when you specify a leading minus before the option identifier ('-'). Options are always specified before file names or project files.

When the assembler is executed options are all preset with default values and are either switched ON or OFF (active or not). All options have a single letter identification. Upper and lower case letters are distinguished, which means that 'a' might be different command than 'A'. If an option is to be turned off, you simply specify a 'n' before the identification, e.g. -nl which selects listing files not to be created by the assembler.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_1></a>

#### 6.2.1. -e\<ext\> : Use alternative source file extension

The default assembler source file extension is ".asm". Using this option, you force the assembler to use another default extension, like ".opt" or ".as" for the source file.

The extension is specified without the ".". Only three letters are accepted - the rest is discarded.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_2></a>

#### 6.2.2. -M\<ext\> : Use alternative object file extension

The default assembler object file extension is ".obj". Using this option, you force the assembler to use another default extension, like ".o" as the object file name extension.

The extension is specified without the ".". Only three letters are accepted - the rest is discarded.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_3></a>

#### 6.2.3. -d : Assemble only updated files

Assemblers usually force compiles all specified files. This is also possible (as default) for the  [Z80](#7)  Module Assembler. In large application project with 15 modules or more it can be quite frustrating to compile all every time. The solution is to only assemble updated files and leave the rest (since they have been compiled to the programmers knowledge).

But in a long term view it is better to just compile a project without thinking of which files need to be compiled or not. That can be done with the  [Z80](#7)  Module Assembler. By simply specifying the  [-d](#6_2_3)  parameter at the command line, only updated source files are assembled into object files - the rest are ignored.

Using the  [-d](#6_2_3)  option in combination with a project file gives the best project setup for a large compilation; compile your projects without worrying about which module is updated or not.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_4></a>

#### 6.2.4. -b : Link/relocate object files

The  [-b](#6_2_4)  option must be used if you want to create an executable  [Z80](#7)  machine code output file of your previously created object files. You may also use the  [-a](#6_2_5)  option which is identical in functionality but also includes the  [-d](#6_2_3)  option. In other words assemble only updated source modules and perform linking/relocation of the code afterwards.

*   Pass 1:  
    When the linking process begins with the first object module, it is examined for an  [ORG](#10_25)  address to perform the absolute address relocation of all the object module machine code. The  [ORG](#10_25)  (loading address for memory) will have to be defined in the first source file module. If not, the assembler will prompt you for it on the command line. The  [ORG](#10_25)  address must be typed in hexadecimal notation. If you never use the  [ORG](#10_25)  directive in your source files, you can always explicitly define one at the command line with the  [-r](#6_2_7)  option.  
      
    The next step in the linking process is loading of the machine code from each object module, in the order of the specified modules. Pass 1 is completed with loading all local and global symbol definitions of the object modules. All relocatable address symbols are assigned the correct absolute memory location (based on  [ORG](#10_25) ).  
    
*   Pass 2:  
    The address patching process. All expressions are now read and evaluated, then patched into the appropriate positions of the linked machine code.  
      
    When all expressions have been evaluated the machine code is completed and saved to a file named as the first source file module, and assigned the 'bin' extension.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_5></a>

#### 6.2.5. -a : Combine -d and -b

Same as providing both  [-b](#6_2_4)  (link/relocate object files) and  [-d](#6_2_3)  (assemble only updated files).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_6></a>

#### 6.2.6. -o\<binary-filename\> : Binary filename

Define another filename for the compiled binary output than the default source filename of the project, appended with the ".bin" extension.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_7></a>

#### 6.2.7. -r\<hex-address\> : Re-define the ORG relocation address

During the linking phase of the assembler the  [ORG](#10_25)  address that defines the position in memory where the code is to be loaded and executed, is fetched from the first object module file. You can override this by specifying an explicit address origin by entering the  [-r](#6_2_7)  option followed by an address in hexadecimal notation at the command line, e.g.:

    z80asm  [-b](#6_2_4)  -r4000 file.asm

which specifies that your code is to be relocated for address 4000h (16384) onward.

Using the  [-r](#6_2_7)  option supersedes a defined  [ORG](#10_25)  in the object file. You could for example have defined the  [ORG](#10_25)  to 8000h (32768) in your first source file, then compiled the project. This would have generated machine code for memory location 8000h (segment 2 in the Cambridge  [Z88](#6_5) ). Since the object files are generated it is easy to link them again with another  [ORG](#10_25)  address by just using the  [-r](#6_2_7)  option. The linking process does not alter the information in object files - they are only read. The same project could then easily be re-linked to another address, e.g.

    z80asm  [-b](#6_2_4)  -r2000 file.asm


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_8></a>

#### 6.2.8. -R : Generate address independent code

The  [Z80](#7)  processor instruction set allows only relative jumps in maximum +/- 128 bytes using the JR and DJNZ instructions. Further, there is no program counter relative call-to-subroutine or jump-to-subroutine instruction. If you want a program to be address-independent no absolute address references may be used in jump or call instructions. If you want to program  [Z80](#7)  address independent code you can only write small routines using the JR and DJNZ instructions. With a restricted interval of 128 bytes you can imagine the size of those routines! Programming of large applications using address Independence is simply impossible on the  [Z80](#7)  processor with the basic instruction set available. You can only define a fixed address origin ( [ORG](#10_25) ) for your machine code to be loaded and executed from. However, there is one solution: before the code is executed an automatic address-relocation is performed to the current position in memory. This is done only once. The penalty is that the program fills more space in memory. This is unavoidable since information must be available to define where the address relocation has to be performed in the program. Further, a small routine must be included with the program to read the relocation information and patch it into the specified locations of the program. It is impossible to determine the extra size generated with a relocation table. We assume an extra size of 3 - 3.5K for a typical 16K application program.

You can generate address independent code using the  [-R](#6_2_8)  option accompanied with the  [-a](#6_2_5)  or  [-b](#6_2_4)  option. There is no other requirements. The relocatable code may be useful for programmers using the Cambridge  [Z88](#6_5)  who want to use machine code in the BBC BASIC application environment. This can easily be interfaced with the DIM statement to allocate memory for the machine code program, and issue a  [CALL](#10_2)  or USR() to execute the machine code.

Please note that the linking process with the  [-R](#6_2_8)  option addresses your code from 0 onward. This is necessary when the runtime relocation is performed by the relocator (just before your program is executed). This can be examined by loading the address map file into a text editor.

The principle of relocation is in fact a self-modifying program. You cannot relocate a program that has been blown into an EPROM (cannot be modified). You may only execute relocatable programs in dynamic memory (RAM).

The relocator is built into the  [Z80](#7)  Module Assembler. The relocation table is created during the linking phase. When all object modules have been linked and the appropriate machine code generated, the process is ended with first copying the relocator routine into the executable file, then a relocation table and finally the compiled machine code program. Any defined  [ORG](#10_25)  in your code is superseded - this is not necessary in a relocatable program!

Two rules must be obeyed when using relocatable programs:

1.  The IY register must have been set up to point at the address where your program resides. The first code is in fact the relocator which manipulates your code on the basis of the IY register. If IY is not setup properly your machine code program will be relocated for an address it is not resided at. On execution your might then call a random address (on the basis of the random IY register).  
    
2.  Don't use the alternate register set for parameter passing between the caller (of your code) in the main code and the relocated program. The following registers are affected by the initial relocation process:

        AFBCDEHL/IXIY/........ same  
        ......../..../afbcdehl different

You still have all the main registers for parameter passing which is more than sufficient for average programming.

When your address-independent code is stored to the file, a message is displayed which informs the user of how many bytes the relocation header consists of. This constant is useful since it informs you of the distance between the relocation header and the start of your code. The map file automatically reflects the relocation header. All addresses of your code has been modified to include the relocation header. Please note that all addresses in the map file are defined from address 0. When your code is placed in an absolute memory address, and you need to perform a debugging session, you can find your specific label address by adding the constant from the map file to the memory origin of your code. The inbuilt relocator routine may be examined by extracting the "relocate.asm" file from the " [Z80](#7) src.zip" compressed file resource.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_9></a>

#### 6.2.9. @\<project-file\> :1.3.16. Using a project file

Project files defines all file names of a project. The file name standard stored in a project file obeys the operating system notation.

Instead of specifying every module file name at the command line, a simple reference of a project file can be made instead. According to the rules of the specification of parameters you specify either your source file modules or use a project file. The project file specification is of course much faster. An example:

    z80asm  [-a](#6_2_5)  main pass1 pass2 link asmdrctv z80instr

This command line will compile all specified module file names into a single executable file called "main.bin". However if a project file 'assembler' were created already containing the same file names, the command line would have been:

    z80asm  [-a](#6_2_5)  @assembler

\- much easier!

A project file only contains file names. Each file name is separated by a newline character \\n. The new line character may be different on various computer platforms - but the assembler interprets it correctly. The contents of a project file may look like this:

    z80asm  
    z80pass1  
    z80pass1  
    modlink

Project files are easily created using a simple text editor.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_10></a>

#### 6.2.10. -i\<library-file\> : Include library modules during linking/relocation

This option allows compilation time linking of external machine code, better known as library routines. Much, much programming time can be saved by producing a set of standard routines compiled into library files. These may then be included later in application project compilations. The command line option allows specification of several library files. For each library reference in an application module, all library files will be scanned for that particular module. The filename (inclusive directory path) of the library may be specified explicitly on the command line immediately after the  [-i](#6_2_10)  identifier. 

Library files are recognised by the ".lib" extension.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_11></a>

#### 6.2.11. -x : Create a library

A library file is composed of object files surrounded by a few file structures. The library file format (and object file format) may be found at the end of this documentation. A library is simply a set of independent routines (that may refer to each other) put together in a sequential form. You may only specify a single  [-x](#6_2_11)  option on the command line. A filename may be explicitly defined (including device and path information) to determine the storage location of the library. A library routine must be defined using a simple  [XLIB](#10_28)  directive with an identical address name label definition. Please refer to further information later in this documentation. The " [Z80](#7) lib.zip" contains the standard library with all corresponding source files. Have a look at them - they clearly displays how to compose a library routine.

One very important aspect of libraries is the time that the assembler spends searching through them. To optimize the search you should place your routines in a "topological" order, i.e. routines that access other library routines should be placed first. In most situations you avoid redundant sequential searching through the library.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_12></a>

#### 6.2.12. -t\<number\> : Define tabulator distance for text output files

To save storage space the  [Z80](#7)  cross assembler output files (listing, map, symbol and  [XDEF](#10_27)  definition files) uses a tabulator control character instead of spaces. The benefit is about 30% compressed files.

The tabulator distance defines the distance of space between each tabulator it represents. The default value is 8 spaces per tabulator.

The tabulators are used to separate two columns of information. The first column contains a name of some sort. Since names have variable length, a size of the column is defined. The Assembler defines the size of the column by multiplying the current tabulator distance with 4, i.e. giving a default size of 4\*8 = 32 'spaces'. This is usually more than enough for most name definitions parsed from source files.

You may redefine the tabulator distance by using the  [-t](#6_2_12)  option immediately followed by a decimal number, e.g. -t4 for defining a tabulator distance of 4. The width of the first column will then be 4\*4 = 16 'spaces'.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_13></a>

#### 6.2.13. -RCMX000 : Support the RCM2000/RCM3000 series of Z80-like CPU's

This option disables assembly opcodes not available in the RCM2000/RCM3000 series of  [Z80](#7) -like CPU's.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_14></a>

#### 6.2.14. -plus : Support for the Ti83Plus

Defines how the  [INVOKE](#10_19)  command is coded: either as a RST 28H instruction (option on) or as a regular  [CALL](#10_2)  instruction (option off).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_2_15></a>

#### 6.2.15. -C : Enable LINE directive

Enables the  [LINE](#10_21)  directive to synchronize error message line numbers with the line numbers from the source file.

2\. An overview of assembler features and related files
-------------------------------------------------------


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_3></a>

### 6.3. The Z88 operating system definition files

You will find header files containing all operating system definitions as defined in the  [Z88](#6_5)  Developers' Notes V3 in the "OZdefc.zip" file. This makes the operating system interface programming a lot easier.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_4></a>

### 6.4. The supplied standard library Z80 source files

We have supplied a standard library with useful routines for both beginners and professional machine code programmers. All source files are supplied for having the opportunity to study and improve the routines. However some routines are programmed especially for the  [Z88](#6_5)  operating system and may not be of use for other  [Z80](#7)  based computers unless thoroughly rewritten. The standard library source files may be found in the " [Z80](#7) lib.zip" file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_5></a>

### 6.5. Z88 module assembler application source

We have supplied the complete source of the  [Z88](#6_5)  module assembler application. This allows you to evaluate many aspects of programming applications on the  [Z88](#6_5) . Further, most features of the assembler are mirrored in these source files; using directives, the free format of  [Z80](#7)  mnemonics, library routine access, modular file design, labels, using expressions, comments, data structure manipulation and good programming design.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_6></a>

### 6.6. File based compilation

This assembler is completely file based, i.e. all parsing and code generation is manipulated via files on storage medias such as harddisks or floppy disks (or file based RAM-discs).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_7></a>

### 6.7. Modular source file design

A compilation may be split into individual source files that either can be linked together during assembly as a single module or assembled as separate source file modules. Separate source file modules saves compilation time and memory. Further, this design is much more straightforward and much more logically clear in a design phase of a large compilation project than one huge kludge of a source file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_8></a>

### 6.8. Scope of symbols in source modules

All source modules may refer to each others symbols by using  [EXTERN](#10_12)  directives. This means that you refer to external information outside the current source module. The opposite of an external module reference is to declare symbols globally available using a  [PUBLIC](#10_26)  directive, i.e. making symbols available to other source modules. Finally it is possible to have local symbols that are not known to other source modules than the current. A label or constant that has not been declared with  [EXTERN](#10_12) ,  [PUBLIC](#10_26)  or  [GLOBAL](#10_14)  is local to the module.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_9></a>

### 6.9. Using arithmetic and relational expressions

All directives that require a numerical parameter or  [Z80](#7)  mnemonics that use an integer argument may use expressions. Expressions may be formed by all standard arithmetic operators and relational operators. Even binary operators are implemented. All expressions may contain external identifiers and is automatically resolved during the linking phase. Only certain directives require compilation time evaluable expressions.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_10></a>

### 6.10. Free format of assembler source files

The source files may be written in a free format. No fixed position columns as needed as in the COBOL programming language. All text may be typed in mixed case (the assembler converts all text input to uppercase). Tabulators may be used freely (instead of spaces which also saves source file space) to suit the programmers own habits of structured text layouts. However, one rule must be obeyed: syntax of  [Z80](#7)  assembler mnemonics and most directives must be completed on individual lines. Text files using different OS dependant line feed standard are parsed properly; line feed types CR, LF or CRLF are automatically recognized. So you can easily compile your sources from Linux/UNIX on an MSDOS platform.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_11></a>

### 6.11. Specification of filenames

Specification of file names in source files are always enclosed in double quotes. The assembler just collects the filename string and uses this to open a file. This way all filename standards may be used as defined on different operating system platforms.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_12></a>

### 6.12. Including other source files into the current source file

The need for header file information such as operating system constants or data structures is often indispensable for source file modules. Instead of copying the contents of those files into each module, it is possible to include them at run time (during parsing). Infinite include file levels are permitted, i.e. included files calling other files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_13></a>

### 6.13. Conditional assembly in source file modules

Large compilation projects often need to compile the application in several variations. This can be achieved with enclosing parts of the source with conditional directives for the different variations of the application. This may also be useful if the assembler source is ported to several platforms, where inclusion of other source files (such as header files) are using different filename standards. The conditional directives  [IF](#10_15) ,  [IFDEF](#10_16) ,  [IFNDEF](#10_17) , ELSE, and ENDIF may be nested into infinite levels.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_14></a>

### 6.14. Undocumented Z80 instruction code generation

We have included the syntax parsing and code generation of the undocumented  [Z80](#7)  instructions for the sake of completeness. However, IM 2 interrupts must be disabled before they are executed (an interrupt may otherwise occur in the middle of the instruction execution). Many games on the ZX Spectrum have used them to protect the code from prying eyes. The  [Z88](#6_5)  native debugger code uses some of the undocumented instructions for fast access to register variables.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_15></a>

### 6.15. Object file generation

The  [Z80](#7)  Module Assembler generates object files that contains the compressed version of an assembled source module. The information herein contains declared symbols (local, global and external), expressions, address origin, module name and machine code. The object file modules are much smaller than their source file counterparts (often smaller than 2K).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_16></a>

### 6.16. Transfer of object files across platforms

The  [Z80](#7)  Module Assembler is already implemented on several different computer platforms. You may freely transfer the object files and use them as a part of another cross-compilation. There is no system-dependent information in the object files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_17></a>

### 6.17. Date stamp controlled assembly

To avoid unnecessary compilation of source file modules, it is possible to let the assembler compile only recently updated source file modules by comparing the date stamp of the source and the object file modules. Source file modules that are older than object file modules are ignored. This facility is indispensable in large compilation projects.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_18></a>

### 6.18. Listing files

The assembler may generate listing files that contain a copy of the source file with additional code generation information of  [Z80](#7)  mnemonics dumped in hexadecimal format. The listing files are formatted with page headers containing time of assembly and the filename. Line numbers are included which corresponds to the source file lines.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_19></a>

### 6.19. Symbol information

All symbol generated values used in source modules may be dumped to the end of the listing file or as a separate symbol file. If the symbol table is dumped into the listing file, each symbol will be written with page references of all occurrences in the listing file. Address symbols (labels) are addressed relative to the start of the module. Symbol constants are written as defined in the source. The symbol table is written in alphabetical order with corresponding values in hexadecimal format.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_20></a>

### 6.20. Linking and relocation of object modules into executable Z80 machine code

To obtain an executable  [Z80](#7)  machine code file it is necessary to link all assembled object modules and relocate them at a defined address, where the code is to be executed at in the computers' memory. The linking & relocation is performed automatically after completed assembly of all specified source file modules. The  [ORG](#10_25)  relocation address is specified in the first object module.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_21></a>

### 6.21. Address map files

The address map is invaluable information during a debugging session of your compiled program. This file contains all symbolical address labels with their generated address constants after a completed linking/relocation of all modules into executable machine code. The map file is ordered in two groups; the first list contains all symbol names ordered alphabetically with corresponding address constants, the second list contains all symbols ordered by their address value (in chronological order).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_22></a>

### 6.22. Symbol address definition files

As with address map files this contains information of globally declared symbolical address labels, relocated to their absolute position as for the compiled machine code file. However, the format is completely different; all symbols are created as constant definitions to be included as a header file into another source file and assembled. This is useful if you want to call subroutines compiled separately in another project (originated in a different memory setup).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_23></a>

### 6.23. Error files

Error files are created by the assembler during processing. If any errors should occur, they will be written to stderr and copied to this file containing information of where the error occurred in the source module. If no errors were found, the error file is automatically closed and deleted.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=6_24></a>

### 6.24. Creating and using object file libraries for standard routines

Machine programmers often re-use their standard routines. We have implemented a file format for generating libraries using the existing object file modules. Using a simple set of rules makes it very easy to create your own libraries from your source file modules. Documentation of the library file format is included in this documentation. At command line infinite number of libraries may be specified. All will be searched during linking of your object modules for referenced library routines.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7></a>

## 7. Z80 module assembler file types


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_1></a>

### 7.1. The assembler file types and their extension names

The  [Z80](#7)  Module Assembler uses several different filename extensions to distinguish the type of files processed. The base name of the source file is used to create the various assembler output file types. The following chapters explains the available files.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_2></a>

### 7.2. The file name extension identifier

The file name extension identifier may be different from platform to platform. UNIX has no defined standard. MSDOS and TOS uses '.'. QDOS uses the '\_' identifier. SMSQ also allows the '.' extension identifier.

The Assembler implemented on the supplied platforms is defined with the correct extension identifier. You can see this on the Assembler help page (executing the program with no parameters).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3></a>

### 7.3. File types


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_1></a>

#### 7.3.1. The source file extension, asm

The extension for assembler mnemonic source files is 'asm'. Source files are specified by the user with or without the extension - whatever chosen, the assembler will investigate automatically what is needed to read the source files.

You may override the default extension with the  [-e](#6_2_1)  option.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_2></a>

#### 7.3.2. The object file extension, obj

The extension for object files is 'obj'. The base file name is taken from the corresponding source file name. This file is generated by the assembler from parsing the source file and contains intermediate generated machine code, an address origin of the machine code, symbol information and expressions.

You may override the default extension with the  [-M](#6_2_2)  option.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_3></a>

#### 7.3.3. The error file extension, err

The extension for error files is 'err'. Before beginning processing the source files, an error file is created. If any errors should occur, they will be written to this file containing information of where the error occurred. If no error were found, the error file is automatically closed and deleted.

Error files are simple text files that can be loaded by any text editor for evaluation.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_4></a>

#### 7.3.4. The listing file extension, lst

The extension for listing files is 'lst'. The base file name is taken from the corresponding source file name. This file is generated by the assembler and contains a hexadecimal output of the generated machine code that corresponds to the  [Z80](#7)  mnemonic instruction or directive, followed by a copy of the original source line. If selected, the symbol table is dumped at the end of the listing file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_5></a>

#### 7.3.5. The symbol file extension, sym

The extension for symbol table files is 'sym'. The base file name is taken from the corresponding source file name. The symbol table file contains information about the defined and used symbols of the source file and their generated values (labels and constants). The symbol file is only created if listing file output is disabled.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_6></a>

#### 7.3.6. The executable file extension, bin

The extension for executable  [Z80](#7)  machine code files is 'bin'. The base file name is taken from the first specified source file name at the command line (or project file). This is the linked and relocated output of object files and may be executed by the  [Z80](#7)  processor. You may override this default behaviour by using the  [-o](#6_2_6)  option and specify your own output filename (and extension).

You may override this default behavior by using the  [-o](#6_2_6)  option and specify your own output filename and extension.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_7></a>

#### 7.3.7. The address map file extension, map

The extension for address map files is 'map'. The base file name is taken from the first specified source file name at the command line (or project file). This file is generated by the assembler and contains a list of all defined address labels from all linked/relocated modules with their calculated (absolute) address in memory.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_8></a>

#### 7.3.8. The definition file extension, def

The extension for global address label definition files is 'def'. The base file name is taken from the first specified source file name at the command line (or project file). This file is generated by the assembler and contains a list of all globally declared address labels with their calculated (absolute) origin address, fetched only during assembly of source file modules. The format of the list contains constant definitions (addresses) and may be parsed e.g. as include files for other projects.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=7_3_9></a>

#### 7.3.9. The library file extension, lib

Library files are identified with the 'lib' extension. Library files may be created using the  [-x](#6_2_11)  option. Library may be included into application code during linking of object modules with the  [-i](#6_2_10)  option.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8></a>

## 8. Compiling files


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_1></a>

### 8.1. The assembler compiling process

The  [Z80](#7)  Module Assembler uses a two stage compilation process; stage 1 parses source files and generates object files. Stage 2 reads the object files and links the object file code, completes with address patching and finishes with storing the executable code.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_1_1></a>

#### 8.1.1. Stage 1, parsing and code generation of all source files, object file generation

A source file is being parsed for  [Z80](#7)  mnemonics and directives. An object file is created to hold information of module name, local, global and external symbol identifiers, expressions and the intermediate code generation (but address and other constant information). During pass 1 all  [Z80](#7)  mnemonics are parsed and code is generated appropriately. All expressions are evaluated; expressions that contain relocatable address symbols or external symbol are automatically stored into the object file. Expressions that didn't evaluate are preserved for pass 2. When a source file has been read successfully to the end, pass 2 is started. During pass 2 all non-evaluated expressions from pass 1 are re-evaluated and stored to the object file if necessary. Errors are reported if symbols are still missing in expressions. When all expressions are evaluated and no errors occurred, all "touched" symbols (used in expressions) are stored into the object file, with scope, type and value. Then, the module name and generated code is stored to the object file. Various file pointers to sub-sections of the object file is resolved. The completion of stage 1 is to produce the symbol table output (either appended to listing file if selected or as a separate file).

This process is performed for all specified source modules in a project.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_1_2></a>

#### 8.1.2. Stage 2, linking object files and library modules, producing executable code

Pass 1 of the linking loads information from each object file in the project; the  [ORG](#10_25)  address is fetched, identifiers (resolving scope, and absolute values) loaded, and machine code linked. During this pass all external library modules are fetched and linked with the object modules (if a library is specified from the command line). When all modules have been loaded, pass 2 begins. Pass 2 then reads each expression section from all object modules (including library modules), evaluates them and patches the value into the appropriate position of the linked machine code. When all expressions have been evaluated successfully the executable code is stored. If selected, the address map file is produced from the current symbol table resided in the data structures of the assembler's memory is stored to a text file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_2></a>

### 8.2. File names

Specification of file names follows the convention used on the various platforms that the assembler is ported to. Please read your operating systems manual for more information.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_3></a>

### 8.3. Portability of assembler file names

If you are going to port your  [Z80](#7)  Module Assembler files across several platforms a few hints may be worth considering:

Avoid special symbols in file names like '\_', '#' and '.' . They may have special meaning on some operating system platforms. Use only 7-bit standard ASCII letters in file names ('A' to 'z'). Non English language letters are not always allowed, and further they may not be interpreted correctly when ported to another platform. Avoid too long file names. Some operating systems have boundaries for length of filenames in a directory path. For example MS-DOS only allows 8 characters in a file name (followed by an extension). Others may have no boundaries.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_4></a>

### 8.4. Source file structure

The composition of a source file module is completely free to the programmer. How he chooses to place the source code on a text line has no effect of the parsing process of the assembler. The linefeed interpretation is also handled by z80asm - it understands the following formats:

*   \<LF\> (used by QDOS/SMSQ/UNIX/AMIGA);
*   \<CR\>\<LF\> (used by MSDOS);
*   \<CR\> (used by  [Z88](#6_5) /MacIntosh).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_5></a>

### 8.5. Using local, global and external symbols

In larger application projects it is unavoidable to use a modular programming design, i.e. splitting the source into several individual files. This approaches the popular top - down design where you can isolate the problem solving into single modules. The outside world just needs to know where the routine is to be called by linking the modules with a few directives.

In the  [Z80](#7)  Module Assembler you only need two directives to accomplish just that: the  [XREF](#10_29)  and  [XDEF](#10_27)  directives.

 [XREF](#10_29)  declares a symbol to be external to the current source file module. This tells the assembler that all expressions using that symbol is not to be evaluated until the compiled object modules are to linked and relocated together. An expression that contains this symbol is simply stored into the object file.

 [XDEF](#10_27)  declares a symbol to be created in this module and made globally available to other modules during the linking/relocation phase. All expressions that contain a globally declared symbol is automatically stored into the object file.

When a symbol is created and is neither declared external or global, it is implicitly defined as local to the current source module. The symbol is then only available to the current module during linking/relocation.

If you want to access (external) library modules from a library, use the  [LIB](#10_20)  directive followed by the name of the routine. Several routine names may be specified separated by a comma.

During the linking process all external and corresponding global symbols are resolved. If two identical global identifiers are loaded by the linking process, the most recently loaded identifier is used by the linker.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_6></a>

### 8.6. Defining symbol names

Good programming involves a structured approach to mnemonic identification of names in subroutines, variables, data structures and other constants. The  [Z80](#7)  Module Assembler gives you several possibilities. The easiest and frequently used one is  [DEFC](#10_6)  (Define Constant). We have supplied a complete set of header files (the "OZdefc.zip" file) containing the  [Z88](#6_5)  operating system manifests as defined in the Developers' Notes V3 (the "devnotes.zip" file) which just contains  [DEFC](#10_6)  directives.

Each  [DEFC](#10_6)  directive is followed by an identifier name, followed by a = symbol and then an evaluable constant expression (usually just a constant). Constant definitions are usually operating system manifest or other frequently used items. They are put into separate source files and later inserted into main source files using the  [INCLUDE](#10_18)  directive.

Though  [DEFC](#10_6)  resolves most needs, it may be necessary to define variable areas or templates containing names with an appropriate size tag (byte, word or double word). This is possible using the  [DEFVARS](#10_11)  directive. Here you may specify as many names as needed in the group. Then, it is easy to add, rearrange or delete any of the variable names - only a few modifications and then just re-compiling the necessary source files that use the templates. This would be a nightmare with  [DEFC](#10_6) , since you have to keep track of the previous and next name in the group in addition to count the size of all names. All this is managed by  [DEFVARS](#10_11)  automatically. Have a look at the syntax in the Directive Reference section.

With advanced  [Z80](#7)  programming you cannot avoid dynamic data structures like linked lists or binary trees. The fundamentals for this are known as records in PASCAL or structures in C.  [DEFVARS](#10_11)  is well suited for this purpose. Defining each  [DEFVARS](#10_11)  group with 0 automatically generates offset variables. The last name then automatically defines the size of the data structure. Again, refer to the directive reference for a good example.

A third possibility for an easy definition of symbols is to use the  [DEFGROUP](#10_8)  directive. Here you're able to define a set of symbols equal to an enumeration. It follows the same principles as for C's ENUM facility. The default starts at 0 and increases by 1. If you choose, a specific identifier may be set to a value, which then can set the next enumeration sequence. Again, this directive has been made to implement an easy way of defining symbols and providing a simple method to alter the identifier group. Please refer to the directive reference for an example.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_7></a>

### 8.7. Comments in source files

As always, good programming requires good documentation. Without comments your programs lose overview and logic. Machine code is especially hard to follow - have you tried to look at a piece of code 2 years after implementation AND without any comments? HORRIBLE! There is never too many comments in machine code - we especially like to use high level language as comments - it avoids unnecessary text and logic is much more clear.

Comments in  [Z80](#7)  source files are possible using a semicolon. When the assembler meets a semicolon the rest of the current source line is ignored until the linefeed. Parsing will then commence from the beginning of the line. The semicolon may be placed anywhere in a source line. As stated you cannot place mnemonics after the semicolon - they will be ignored. The  [Z80](#7)  parser will in many places accept comments without a semicolon has been set - but don't rely on it. Better use a semicolon. The context is much clearer. The following is an example on how to use comments in  [Z80](#7)  source files:

    ; **********************  
    ; main menu  
    ;  
    .mainmenu   call window   ; display menu  
                call getkey   ; read keyboard  
                ret           ; action in register A


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_8></a>

### 8.8. Defining symbolic address labels

The main reason for using an assembler is to be able to determine symbolical addresses and use them as reference in the code. These are defined by a name preceded with a full stop, or followed by a colon. It is allowed to place a mnemonic or directive after an address label. An address label may be left as a single statement on a line - you may of course use comment after the label. The following is a label definition:

    ; *****************  
    ; routine definition  
    .mainmenu call xxx   ; a label is preceded with '.'
    endmain:  ret                ; or followed by ':'

It is not allowed to position two labels on the same line. However, you may place as many label after each other - even though no code is between them. They just receive the same assembler address.

It is not allowed to specify two identical address labels in the same source file.

If you want to declare an address globally accessible to other modules, then use  [PUBLIC](#10_26)  for the address label definition, otherwise the label definition will be interpreted as a local address label.

     [PUBLIC](#10_26)  mainmenu  
    ...  
    .mainmenu ; label accessible from other modules with  [EXTERN](#10_12) 

You may use before or after the label - z80asm automatically handles the scope resolution as long as you use  [PUBLIC](#10_26)  to define it as globally accessible.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_9></a>

### 8.9. Writing Z80 mnemonic instructions

All  [Z80](#7)  instructions may be written in mixed case, lower or upper case - you decide! How you separate opcode words, register names and operands is your choice. Only a few rules must be obeyed:

1.  Each instruction mnemonic must be completed on a single line.
2.  The instruction identifier must be a word, i.e. don't use space between  [CALL](#10_2) .
3.  Register identifiers must be a word, ie. HL not H L.

A few examples which all are legal syntax:

    Ld HL   , 0       ; comment  
    ld       hl, $fFFF;comment  
    caLL ttttt


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_10></a>

### 8.10. Optional Z80 mnemonic instruction syntax

The instructions below allow additional specification of the accumulator register. Zilog standard convention is to only specify the source operand. Sometimes it is better to specify the accumulator to make the instruction look more clear, and to avoid confusion. After all, they specified it for "add", "adc" and "sbc".

    sub a,r  
    sub a,n  
    sub a,(hl)  
    sub a,(ix+0)  
    sub a,(iy+0)

this syntax applies also to "and", "or", "xor" & "cp"


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_11></a>

### 8.11. The undocumented Z80 instructions

We have included the parsing and code generation of the undocumented  [Z80](#7)  instructions. They are as follows:

    LD   r,IXL  ; r = A,B,C,D,E,IXL,IXH  
    LD   r,IXH  
    LD   IXL,n  ; n = 8-bit operand  
    LD   IXH,n  
  
    ADC  A,IXL  
    ADC  A,IXH  
    ADD, AND, CP, DEC, INC, OR, SBC, SUB, XOR ...  
  
    SLL  r   ; r = A,B,C,D,E,H,L  
    SLL  (HL)
    SLL  (IX+d)
    SLL  (IY+d)

SLL (Shift Logical Left)

SLL does shift leftwards but insert a '1' in bit 0 instead of a '0'.

Except for the SLL instruction all have bugs related to an interrupt being able to occur while the instructions are decoded by the processor. They are implemented on the chip, but are reported to be unreliable. We have used some of them in our debugger software for the  [Z88](#6_5) . Until now the code has been running successfully on all our  [Z88](#6_5)  computers.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_12></a>

### 8.12. Referencing library routines

When you need to use a library routine in your application code, you need to do two things; include a library file at the assembler command line with the  [-i](#6_2_10)  option and refer to the library routine in your source file using the  [LIB](#10_20)  directive followed by the name of the library routine, e.g.

     [LIB](#10_20)  malloc, free

which will declare the two names "malloc" and "free" as external identifiers to the current source file module. Please note that you can declare the names before or after they actually are referred in your program source,. Failing to use the  [LIB](#10_20)  directive will interpret labels as local symbols to that source file module. When the parser meets the instruction that uses one of the above names in a parameter, the parameter "expression" is automatically saved to the object file for later processing.

During the linking phase of all the object files the specified library file is automatically scanned for "malloc" and "free" and included into the application code when found.

Much application programming can be saved in "re-inventing the wheel" if you store frequently used standard routines in libraries. We have supplied a comprehensive set of library routines that were created along the development of the Assembler Workbench application EPROM. Use them as appropriate and add new ones. We are interested in your work - if you feel that you have made some good routines that others may benefit from, e-mail them to us and we will include them into the standard library.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_13></a>

### 8.13. Creating/updating libraries

Creating libraries is an inbuilt feature of the assembler. The following steps are necessary to create a library:

1.  Define a project file containing all filenames (without extensions) in your directory that contains all library routines (the easiest method since you later can move all files to another directory). 
    
2.  Each library source module uses the  [XLIB](#10_28)  directive to define the name of the routine. The same name must be used for the address label definition. If your library uses other library routines then declare them with the  [LIB](#10_20)  directive. Please note that a library routine creates the module name itself (performed by  [XLIB](#10_28)  automatically). The module name is used to search for routines in a library.  
    
3.  The command line contains the  [-x](#6_2_11)  option immediately followed by your filename. Then you need to specify your project filename preceded by '@'.

For example:

    z80asm -xiofunctions @iofunctions

will create a library "iofunctions.lib" in the current directory (also containing all library source files). The project file is "iofunctions" also in the current directory.

Please note that no binary file is created (a library is NOT an executable file), but a collection of object files sequentially organized in a file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=8_14></a>

### 8.14. Referencing routines in other compiled projects

It may be necessary in some situations to get access to routines previously compiled in another project. This implies however a knowledge of their absolute addresses during linking. This information is stored in the map file, but not accessible in a form suitable to be parsed by the assembler. However, this is possible in using the  [-g](#3_7_4)  option at the assembler command line. The action performed creates a  [DEFC](#10_6)  list file of address labels that have been declared as globally available (using the  [XDEF](#10_27)  directive). Only compiled source files are included in the list. If you were using the  [-a](#6_2_5)  option (compile only updated source files) and no files were updated then the  [-g](#3_7_4)  file would be empty. If you would like a complete list of all global routines then it is needed to compile the whole project (using the  [-b](#6_2_4)  command line option).

When the file is generated, it can easily be  [INCLUDE](#10_18) 'd in another project where your routines may access the external routines. You might do this in two ways:

1.  Including the file in every source module that needs to access external routines. This may be the easiest solution if you're only going to need external access in one or two source modules. With many external calls in different module of the current project it requires much altering of files.  
    
2.  Creating a new source file that is part of your project. This file could easily be the first file in your project but could just as well be placed anywhere in your project. Declare each external name that is needed somewhere in your project as  [XDEF](#10_27) , meaning that all names to be included are globally accessible from this module. Then specify the  [INCLUDE](#10_18)  of the  [DEFC](#10_6)  list of the other project file. As the names get loaded, they become global definitions. All other definitions will be ignored and not stored to the object file (they are not referred in the source module). All other modules just need to specify the external names as  [XREF](#10_29) . During linking they all get resolved and your code has access to external routines from a previously compiled project.

Whenever the previous project has been re-compiled (and issued with  [-g](#3_7_4)  option) there is a possibility that routine addresses has changed. You therefore need to recompile the extra source module in your project to get the new identifier values - the rest of your compilation is unaffected (due to the  [XREF](#10_29)  directives). Only the linking process gets the new proper addresses. In example 1) you had to recompile all source files that would have used an  [INCLUDE](#10_18)  of the  [DEFC](#10_6)  list file. In example 2) only one file had to be recompiled.

The principle of external addresses was used to compile the debugger version to be resided in segment 0 (into the upper 8K). The actual size of the debugger code uses 16K, but was split into two separate halves to fit into the upper 8K of segment 0. Each of the 8K code-segments had to get access to the other 8K block. The solution was the  [-g](#3_7_4)  option and cross referencing using  [XREF](#10_29)  and an additional source module (containing the  [XDEF](#10_27)  declarations) that included the  [-g](#3_7_4)  list file of the other project compilation.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=9></a>

## 9. Using expressions

Expressions are almost unavoidable in source files. They define and explain things much clearer than just using a constant. The  [Z80](#7)  Module Assembler allows expressions wherever a parameter is needed. This applies to  [Z80](#7)  mnemonic instructions, directives and even in character strings. The resulting value from an evaluated expression is always an integer. All expressions are calculated internally as 32-bit signed integers. However, the parameter type defines the true range of the expression. E.g. you cannot store a 32-bit signed integer at an 8-bit LD instruction like LD A, \<n\> . If a parameter is outside an allowed integer range an assembly error is reported. Finally, no floating point operations are needed by the assembler. There is no real standard on  [Z80](#7)  based computers.

Whenever an integer is stored in a  [Z80](#7)  file, the standard Zilog notation is used, i.e. storing the integer in low byte, high byte order (this also applies to 32-bit integers). This standard is also known as little endian notation (also used by INTEL processors).

Expressions may be formed as arithmetic and relational expressions. Several components are supported: symbol names (identifiers), constants, ASCII characters and various arithmetic operators.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=9_1></a>

### 9.1. Constant identifiers

Apart from specifying decimal integer numbers, you are allowed to use hexadecimal constants, binary constants and ASCII characters. The following symbols are put in front of the constant to identify the type:

    $ : hexadecimal constant, e.g. $4000 (16384).  
    @ : binary constant, e.g. @11000000 (192).  
    ' ' : ASCII character, e.g. 'a'.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=9_2></a>

### 9.2. Arithmetic operators

All basic arithmetic operators are supported: addition, subtraction, multiplication, division and modulus. In addition binary logical operators are implemented: binary AND, OR and XOR.

    + : addition, e.g. 12+13  
    - : unary minus, subtraction. e.g. -10, 12-45  
    * : multiplication, e.g. 45*2 (90)  
    / : division, e.g. 256/8 (32)  
    % : modulus, e.g. 256%8 (0)  
    ** : power, e.g. 2**7 (128)  
    & : binary AND, e.g. 255 & 7 (7)  
    | : binary OR, e.g. 128 | 64 (192)  
    ^ : binary XOR, e.g. 128 ^ 128 (0)  
    ~ : binary NOT, e.g. (~0xAA) & 0xFF (0x55)

Arithmetic operators use the standard operator precedence, shown from highest to lowest:

    constant identifiers  
    () ** */% +-&|^~

If you want to override the default operator precedence rules, use brackets ().


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=9_3></a>

### 9.3. Relational operators

With relational operators you may form logical expressions resulting in true or false conditions. The resulting value of a true expression is 1. The resulting value of a false expression is 0. These operators are quite handy when you need to perform complex logic for conditional assembly in  [IF](#10_15) -ELSE-ENDIF statements. The following relational operators are available:

    = : equal to  
    <> :not equal to  
    < : less than  
    > : larger than  
    <= : less than or equal to  
    >= : larger than or equal to  
    ! : not

You may link several relational expressions with the binary operators AND, OR and XOR. You have all the possibilities available!

It is perfectly legal to use relational expressions in parameters requiring an arithmetic value. For example:

    LD A, (USING_IBM = 1) | RTMFLAGS


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=9_4></a>

### 9.4. The ASMPC standard function

In occasional circumstances it may be necessary to use the current location of the assembler program counter in an expression e.g. calculating a relative distance. This may be done with the help of the ASMPC identifier. An example:

    .errmsg0  [DEFB](#10_3)  errmsg1 - ASMPC - 1 , "File open error"  
    .errmsg1  [DEFB](#10_3)  errmsg2 - ASMPC - 1 , "Syntax error"  
    .errmsg2

Here, a length byte of the following string (excluding the length byte) is calculated by using the current ASMPC address value.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=9_5></a>

### 9.5. Symbol identifiers in expressions

Apart from using integer constants in your expressions, names are allowed as well. This is frequently used for symbolical address label references (both external and local).

Forward referencing of symbols is not really something that is important in evaluating expressions. The logic is built into the assembler parser. If an expression cannot be resolved in pass 1 of source file parsing, it will try to re-evaluate the failed expression in pass 2 of the parsing. If it still fails a symbol has not been found ( [XREF](#10_29)  and  [LIB](#10_20)  external symbols are handled during the linking phase).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10></a>

## 10. Directive reference

The  [Z80](#7)  Module Assembler directives are used to manipulate the  [Z80](#7)  assembler mnemonics and to generate data structures, variables and constants. You are even permitted to include binary files while code generation is performed.

As the name imply they direct the assembler to perform other tasks than just parsing and compiling  [Z80](#7)  instruction mnemonics. All directives are treated as mnemonics by the assembler, i.e. it is necessary that they appear as the first command identifier on the source line (NOT necessarily the first character). Only one directive is allowed at a single source line. Even though they are written as CAPITALS in this documentation they may be written in mixed case letters in your source files.

Since the directives cover very different topics of assembler processing, each directive will be explained in detail, identified with a header description for each text section. The following syntax is used:

    <> : defines an entity, i.e. a number, character or string.  
    {} : defines a an optional repetition of an entity.  
    [] : defines an option that may be left out.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_1></a>

### 10.1. BINARY "filename"

 [BINARY](#10_1)  loads a binary file at the current location. This could for example be a static data structure or an executable machine code routine. The loaded binary file information is included into the object file code section. The assembler PC is updated to the end of the loaded binary code.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_2></a>

### 10.2. CALL\_OZ \<expression\>

The \<expression\> may be a 16-bit expression and must evaluate to a constant. This is an easy interface call to the  [Z88](#6_5)  operating system. This is an advanced RST 20H instruction which automatically allocates space for the size of the specified parameter (either 8-bit or 16-bit). Code is internally generated as follows:

    RST $20  
     [DEFB](#10_3)  x ; 8-bit parameter

or

    RST $20  
     [DEFW](#10_4)  x ; 16-bit parameter


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_3></a>

### 10.3. DEFB \<8-bit expr\>,{\<8-bit expr\>} (-128; 255)

Stores a sequence of bytes (8-bits) at the current location. Expressions may be used to calculate the values.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_4></a>

### 10.4. DEFW \<16-bit expr\>,{\<16-bit expr\>} (-32768; 65535)

Stores a sequence of words (16-bits) in low byte - high byte order (little endian) at the current location. Expressions may be used to calculate the values.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_5></a>

### 10.5. DEFL \<32-bit expr\>,{\<32-bit expr\>} (-2147483647; 4294967295)

Stores a sequence of double-words (32-bits) in low byte - high byte order (little endian) at the current location. Expressions may be used to calculate the values.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_6></a>

### 10.6. DEFC name=\<32-bit expression\>{, name=\<32-bit expression\>}

Define a symbol variable, that may either be a constant or an expression evaluated at link time. The allowed range is a signed 32-bit integer value. All standard  [Z88](#6_5)  operating system header files use  [DEFC](#10_6) 


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_7></a>

### 10.7. DEFM \<string expression\>|\<8-bit expr\>,...

 [DEFM](#10_7)  stores a string constant at the current location. Strings are enclosed in double quotes, e.g. "abcdefgh". Strings may be concatenated with byte constants using commas. This is useful if control characters need to be a part of the string and cannot be typed from the keyboard. Several strings and byte expressions may be concatenated, e.g.

     [DEFM](#10_7)  "string_a" , "string_b" , 'X' , CR , LF , 0


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_8></a>

### 10.8. DEFGROUP '{' name {',' name \['=' \<8-bit expression\>\]} '}'

 [DEFGROUP](#10_8)  defines a group of identifier symbols with implicit values. This is similar to the enumeration principles used in C and PASCAL. The initial symbol value is 0, increased by 1 for each new symbol in the list. You may include a \<name = expression\> which breaks the linear enumeration from that constant. The  [DEFGROUP](#10_8)  directive may be spanned across several lines and MUST be enclosed with { and }.  [DEFGROUP](#10_8)  is just a more easy way than:  [DEFC](#10_6)  name0 = 0, name1 = name0, ...

The following example illustrates a useful example of defining symbol values:

     [DEFGROUP](#10_8)   
    {  
       sym_null  
       sym_ten = 10, sym_eleven, sym_twelve  
    }


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_9></a>

### 10.9. DEFINE name,{name}

Defines a symbol identifier as logically true (integer \<\> 0). The symbol will be created as a local variable and disappears when assembly is finished on the current source file module.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_10></a>

### 10.10. DEFS \<size\>{, \<fill-byte\>}

 [DEFS](#10_10)  allocates a storage area of the given size with the given fill-byte. The fill-byte defaults to zero if not supplied. Both expressions need to be constants.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_11></a>

### 10.11. DEFVARS \<16-bit expression\> '{' \[\<name\>\] \[\<storage\_size\> \<size\_multiplier\>\] '}'

 [DEFVARS](#10_11)  defines variable address area or offsets. First you define the origin of a variable area. This may be defined using an evaluable 16-bit positive expression. Each variable name is followed by a size specifier which can be  'ds.b' (byte), 'ds.w' (word), 'ds.p' (3-byte pointer) or 'ds.l' (double-word). This is particularly useful for defining dynamic data structures in linked lists and binary search trees. Defining variable areas are only template definitions not allocations. An example:

     [DEFVARS](#10_11)   [Z80](#7) asm_vars  
    {  
       RuntimeFlags1 ds.b 1     ; reserve 1 byte  
       RuntimeFlags2 ds.b 1  
       RuntimeFlags3 ds.b 1  
                     ds.w 1     ; space not named  
       explicitORIG  ds.w 1     ; reserve 2 bytes  
       asmtime       ds.b 3     ; reserve 3 bytes  
       datestamp_src ds.b 6     ; reserve 6 bytes  
       datestamp_obj ds.b 6  
       TOTALERRORS   ds.l 1     ; reserve 4 bytes  
    }

the following is useful for defining dynamic data structures:

     [DEFVARS](#10_11)  0                    ; 'PfixStack' structure  
    {  
       pfixstack_const     ds.l 1    ; stack item value  
       pfixstack_previtem  ds.p 1    ; pointer to previous  
       SIZEOF_pfixstack              ; size of structure  
    }

This type of variable declaration makes it very easy for modifications, e.g. deleting or inserting variable definitions.

A special logic is available too which can be used throughout individual source files during compilation. If you specify -1 as the starting address, the last offset from the previous  [DEFVARS](#10_11)  which was not specified as 0 will be used.

This enables you to gradually build up a list of identifier name offsets across  [DEFVARS](#10_11)  areas in different source files. The following example explains everything:

    defvars $4000  
    {  
       aaa ds.b 1  
       bbb ds.b 100  
    }  
    defvars -1  
    {  
       ccc ds.b 100  
       ddd ds.b 1  
       eee ds.b 10  
    }  
    defvars 0  
    {  
       fff ds.p 1  
       ggg ds.b 1  
       hhh ds.w 1  
       iii ds.p 1  
    }  
    defvars -1  
    {  
       jjj ds.b 100

    }

Some of the symbols will look like this:

    BBB = $4001  
    CCC = $4065  
    GGG = $0003  
    JJJ = $40D4


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_12></a>

### 10.12. EXTERN name {, name}

This declares symbols as external to the current module. Such a symbol must have been defined as  [PUBLIC](#10_26)  in another module for the current module to be able to use the symbol (it will be linked during the linking phase).



----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_13></a>

### 10.13. FPP \<8-bit expression\>

Interface call to the  [Z88](#6_5)  operating systems' floating point library. This is easier than writing:

    RST $18  
     [DEFB](#10_3)  mnemonic

This is an advanced RST 18H instruction which automatically allocates space for the specified parameter. All  [Z88](#6_5)  floating point call mnemonics are defined in the "fpp.def" file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_14></a>

### 10.14. GLOBAL name {, name}

The  [GLOBAL](#10_14)  directive defines a symbol  [PUBLIC](#10_26)  if it has been defined locally or  [EXTERN](#10_12)  otherwise.



----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_15></a>

### 10.15. IF \<logical expression\> ... \[ELSE\] ... ENDIF

This structure evaluates the logical expression as a constant, and compiles the lines up to the ELSE clause if the expression is true (i.e. not zero), or the lines from ELSE to ENDIF if is is false (i.e. zero). The ELSE clause is optional. This structure may be nested.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_16></a>

### 10.16. IFDEF \<name\> ... \[ELSE\] ... ENDIF

This structure checks if the give symbol name is defined, and compiles the lines up to the ELSE clause if true (i.e. defined), or the lines from ELSE to ENDIF if false (i.e. not defined). The ELSE clause is optional. This structure may be nested.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_17></a>

### 10.17. IFNDEF \<name\> ... \[ELSE\] ... ENDIF

This structure checks if the give symbol name is not defined, and compiles the lines up to the ELSE clause if true (i.e. not defined), or the lines from ELSE to ENDIF if false (i.e. defined). The ELSE clause is optional. This structure may be nested.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_18></a>

### 10.18. INCLUDE "filename"

Another component that is frequently used is to 'link' an additional source file together with the current source file. Usually this contains variable definitions that are commonly used by several modules in a project. This makes sense since there is no idea in copying the same information into several files - it simply uses redundant space of your storage media. This is certainly important on the  [Z88](#6_5)  which not always has huge amounts of installed user/system RAM (usually 128K). The external source file will be included at the position of the  [INCLUDE](#10_18)  directive.

The format of the filename depends on the operating system platform. As with the current source file, you may also insert files in include files. There is no limit of how many levels (of files) you specify of include files. Recursive or mutually recursive  [INCLUDE](#10_18)  files (an  [INCLUDE](#10_18)  file calling itself) is not possible - the assembler program will immediately return an error message back to you!

Include files are usually put at the start of the source file module but may be placed anywhere in the source text. The current source file will be continued after the  [INCLUDE](#10_18)  directive when the included file has been parsed to the end of file.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_19></a>

### 10.19. INVOKE \<16-bit expression\>

Special  [CALL](#10_2)  instruction for the Ti83 calculator; it is coded as a RST 28H followed by the 16-bit expression, if the  [-plus](#6_2_14)  option is passed on the command line (for the Ti83Plus), or as a normal  [CALL](#10_2)  instruction if the option is not passed.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_20></a>

### 10.20. LIB name {,name}

This directive is obsolete. It has been replaced by the  [EXTERN](#10_12)  directive (See changelog.txt at the root of the z88dk project).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_21></a>

### 10.21. LINE \<32-bit expr\> \[ , "file-name" \]

Used when the assembler is used as the back-end of a compiler to synchronize the line numbers in error messages to the lines from the compiled source. 


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_22></a>

### 10.22. LSTOFF

Switches listing output to file off temporarily. The listing file is not closed.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_23></a>

### 10.23. LSTON

Enables listing output (usually from a previous  [LSTOFF](#10_22) ). Both directives may be useful when information from  [INCLUDE](#10_18)  files is redundant in the listing file, e.g. operating system definitions.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_24></a>

### 10.24. MODULE name

This defines the name of the current module. This may be defined only once for a module. All source file modules contain a module name. This name is used by the assembler when creating address map files and for searching routines in libraries. Further, it allows the programmer to choose a well-defined name for the source file module. The position of the module name is of no importance; it may be placed at the end or the start of the source file. However, it has more sense to put it at the top. The syntax is simple - specify a legal identifier name after the  [MODULE](#10_24)  directive, e.g.  [MODULE](#10_24)  main\_module


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_25></a>

### 10.25. ORG \<16-bit expression\>

Define address origin of compiled machine code - the position in memory where the machine is to be loaded and executed. The expression must be evaluable (containing no forward or external references). All address references will be calculated from the defined  [ORG](#10_25)  value. The  [ORG](#10_25)  address will be placed in the current module that is being compiled. However, during linking only the first object module is being read for an  [ORG](#10_25)  address. The  [ORG](#10_25)  is ignored during linking if you have specified an  [-r](#6_2_7)  option on the command line.

When assembling programs with multiple sections, a section without an  [ORG](#10_25)  will be appended to the end of the previous section. A section with a defined  [ORG](#10_25)  will generate its own binary file, e.g. file\_CODE.asm.

A section may contain  [ORG](#10_25)  -1 to tell the linker to split the binary file of this section, but continue the addresses sequence from the previous section.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_26></a>

### 10.26. PUBLIC name {, name}

This directive declares symbols publicly available for other modules during the linking phase of the compilation process.


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_27></a>

### 10.27. XDEF name {, name}

This directive is obsolete. It has been replaced by the  [PUBLIC](#10_26)  directive (See changelog.txt at the root of the z88dk project).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_28></a>

### 10.28. XLIB name

This directive is obsolete. It has been replaced by the  [PUBLIC](#10_26)  directive (See changelog.txt at the root of the z88dk project).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=10_29></a>

### 10.29. XREF name {, name}

This directive is obsolete. It has been replaced by the  [EXTERN](#10_12)  directive (See changelog.txt at the root of the z88dk project).


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=11></a>

## 11. Run time error messages

The following error messages will be written toe the error files corresponding to each source file, and also to stderr. Each error message will contain the name of the source file and a line number where the error occurred in the file.

*   "File open/read error"  
    You have tried to access a file that either was not found, already opened by other resources, or the assembler wasn't able to create output files (object file, listing-, symbol-, map- or executable binary file).  
    
*   "Syntax error"  
    This is a message used by many routines - hence the general but descriptive message. You have tried to use illegal registers in  [Z80](#7)  mnemonic instructions, specified an illegal parameter type (string instead of integer), omitted a parameter ( [DEFB](#10_3)  without constant).  
    
*   "Symbol not defined"  
    This error is given if you are referring to an identifier (usually in an address reference) that was not declared. Either a label definition is missing in the current module or you have forgotten to declare an identifier as external using the  [XREF](#10_29)  directive.  
    
*   "Not enough memory" / "No room in  [Z88](#6_5) "  
    Well, well. It seems that there wasn't enough room to hold the internal data structures during parsing or linking your code. Delete any unnecessary running applications/jobs then try again. If you got the message on the  [Z88](#6_5) , try also to delete unnecessary files from the filing system of your current RAM card.  
    
*   "Integer out of range"  
    You have an expression which evaluates into a constant that are beyond the legal integer range (e.g. trying to store a 16-bit value into an 8-bit parameter).  
    
*   "Syntax error in expression"  
    Quite clearly you have made an illegal expression, e.g. specifying two following operands without an operator to separate them, used an illegal constant specifier or using illegal characters that aren't a legal identifier.  
    
*   "Right bracket missing"  
    Your expression is using brackets and is not properly balanced, i.e. too many beginning brackets or too few ending brackets.  
    
*   "Source filename missing"  
    There has not been specified any source file modules or project file to start a compilation.  
    
*   "Illegal option"  
    The command line parser couldn't recognise the -option. Remember to specify your option in EXACT case size. You have probably used a space between an option and a filename parameter.  
    
*   "Unknown identifier"  
    The parser expected a legal identifier, i.e. a directive or  [Z80](#7)  mnemonic. You have probably omitted the '.' in front of a label definition, misspelled a name or used a comment without a leading ';'.  
    
*   "Illegal identifier"  
    You have been trying to use a name that is either not known to the parser or an illegal identifier. This might happen if you try to use a register that is not allowed in a LD instruction, e.g. LD A,F .  
    
*   "Max. code size reached"  
    Is that really possible? Very interesting code of yours!  [Z80](#7)  machine code program tend to be in the 32K range (at least on the  [Z88](#6_5) )... Well, the  [Z80](#7)  processor cannot address more than 64K. Start changing your code to a smaller size!  
    
*   "errors occurred during assembly"  
    Status error message displayed on the screen when the assembler has completed its parsing on all modules. You have one or more errors to correct in your source files before the assembler continues with linking the next time.  
    
*   "Symbol already defined"  
    In the current source file, you have tried to create two identical address label definitions, or other name identifier creators (using  [DEFC](#10_6) ,  [DEFVARS](#10_11) ,  [DEFGROUP](#10_8) ).  
    
*   "Module name already defined"  
    You have used the  [MODULE](#10_24)  directive more than once in your source file, or used both a  [MODULE](#10_24)  and  [XLIB](#10_28)  directive (library modules only need an  [XLIB](#10_28) ).  
    
*   "Symbol already declared local"  
    You have tried to declare a symbol as  [XREF](#10_29) , but it was already defined local, eg. using a ".lbaddr" in your source.  
    
*   "Illegal source filename"  
    You have tried to specify an option after having begun to specify filenames. Options must always be specified before filenames or project files.  
    
*   "Symbol declared global in another module"  
    You have two identical  [XDEF](#10_27)  definitions in separate modules. One of them should probably be an  [XREF](#10_29)  instead.  
    
*   "Re-declaration not allowed"  
    You are trying to specify an  [XDEF](#10_27)  for a name that has already been  [XREF](#10_29) 'ed in the same module (or the other way around).  
    
*   " [ORG](#10_25)  already defined"  
    Only one  [ORG](#10_25)  statement is allowed per section.  
    
*   "Relative jump address must be local"  
    You have tried to JR to a label address that is declared as external (with  [XREF](#10_29)  or  [LIB](#10_20) ). JR must be performed in the current source file module.  
    
*   "Not a relocatable file" / "Not an object file"  
    The assembler opened a supposed object file (with the proper ".obj" extension) but realised it wasn't conforming to the  [Z80](#7)  assembler standard object file format.  
    
*   "Couldn't open library file"  
    The library file was found but couldn't be opened (probably already opened by another application resource)  
    
*   "Not a library file"  
    Your library file is not a library file (at least is not of the correct file format used by this assembler). Have you maybe used another "library" file? The  [Z80](#7)  library file could also be corrupted (at least in the header).  
    
*   "Cannot include file recursively"  
    A file was tried to be included which was already included at a previous include level.  [INCLUDE](#10_18)  "a.h" cannot contain an  [INCLUDE](#10_18)  "a.h".


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=12></a>

## 12. Backlog

- Doing
    - Implement -E to generate pre-processed output in a .i file

- Preprocessor
    - Parse TASM input
    - Parse Z80MR input
    - high level structures
    - macros
    - architecture-specific macro-like opcodes
    - architecture-specific character encoding
    - JR to JP optimization for speed
    - preprocessor
    - separate scanner from preprocessor  

- Assembler
    - JP to JR optimization for size
    - compile expressions
    - object files store list of input files and command line so that  [-d](#6_2_3)  can decide if it is necessary to recompile
    - object files can store same code for multiple architectures
    - recursive parsing of @lists
    - parse expressions  

- Linker
    - section groups
    - overlays
    - absolute memory areas with holes

- Librarian
    - object files and library files have an index of all defined symbols

- Unsorted Backlog
    - compute compile-time constants  
    - execute compile-time  [IF](#10_15) /ELSE/ENDIF  
    - do not process preprocessor directives in the false branch of  [IF](#10_15)   
    fails building z88dk because  [INCLUDE](#10_18)  of unexistent file guarded by
     [IF](#10_15)  FALSE is processed and assembly fails  
    - process C_LINE  
    - fix list files when parsing a .i
    - move all directives from z80asm to z80asm2  
    - handle  [-m](#3_7_3)  for architecture specific code  
    - handle -D and -U for top-level defines
    - process  [INCLUDE](#10_18)  / INCBIN /  [BINARY](#10_1)   
    - generate .i file  
    - indicate syntax error location  
    - process labels  
    - process  [INCLUDE](#10_18)   
    - process  [BINARY](#10_1) /INCBIN  
    - bug rst label
    - Implement recursive includes in Coco/R parser/scanner
    - Separate standard  [Z80](#7)  assembly from extensions; add macro files for extensions.
    - Port to C++
    - Parse command line
    - Input source
    - Preprocess
    - Lexing
    - Parsing
    - Symbol Table
    - Object Files
    - Assembling 
    - Linking
    - List file
    - allow EQU as synonym to  [DEFC](#10_6) 
    - finish the split between front-end and back-end;
    - implement an expression parser with a parser generator, to get rid of
    the need to write a '#' to tell the assembler something it should know:
    a difference between two addresses is a constant;
    - add an additional step to automatically change JR into JP if the
    distance is too far;
    - implement macros inside the assembler
    - add high level constructs ( [IF](#10_15)  flag / ELSE / ENDIF, 
    DO WHILE flag, ...)
    - add a rule based optimizer based on RAGEL as a state machine generator
    - --icase option
    - --c-strings or --asm-strings
    - architectire-dependent character mapping
    - Test: jr: jr jr
    - Need option to debug pre-processing and macro expansion - -E
    - Add one opcode
    - Separate standard  [Z80](#7)  assembly from extensions; add macro files for extensions
    - Preprocess
    - Parsing
    - Symbol Table
    - Object Files
    - Assembling
    - Linking
    - List file
    - allow EQU as synonym to  [DEFC](#10_6) 
    - finish the split between front-end and back-end;
    - implement an expression parser with a parser generator, to get rid of the need to write a '#' to tell the assembler something it should know: a difference between two addresses is a constant;
    - add an additional step to automatically change JR into JP if the distance is too far;
    - cleanup the symbol table to implement the  [GLOBAL](#10_14)  suggestion: declare a symbol  [GLOBAL](#10_14)  and it is  [PUBLIC](#10_26)  if defined, or  [EXTERN](#10_12)  otherwise
    - implement macros inside the assembler
    - add high level constructs ( [IF](#10_15)  flag / ELSE / ENDIF, DO WHILE flag, ...)
    - add a rule based optimizer based on RAGEL as a state machine generator
    - BUG_0038: library modules not loaded in sequence: The library modules loaded to the linked binary file should respect the order given on the command line.
    - generate .err files with errors
    - show source line and syntax error location 
    - section name: introduces a new section at the end of the current list
    - section name before name: introduces a new section before the given section
    - section name after name: introduces a new section after the given name
    - org:
    1. Any section with an  [ORG](#10_25)  address starts a new area of code and generates 
        a new binary output file, named <first_module_name>_<section_name>.bin
    2. Any section that has no  [ORG](#10_25)  address gets packed at the end of the previous section.
    - The null section is only special in the sense that the code is output 
    to <first_module_name>.bin, and that it's  [ORG](#10_25)  address can be defined in 
    the command line via -rhhhh.
    - simplify expressions to tranform LABEL1-LABEL2 into a constant
    - --icase option
    - --c-strings or --asm-strings
    - architecture-dependent character mapping
    - Test: jr: jr jr
    - Need option to debug pre-processing and macro expansion - -E
    - Add one opcode
    - Separate standard  [Z80](#7)  assembly from extensions; add macro files for extensions
    - Preprocess
    - Parsing
    - Symbol Table
    - Object Files
    - Assembling
    - Linking
    - List file
    - allow EQU as synonym to  [DEFC](#10_6) 
    - finish the split between front-end and back-end;
    - implement an expression parser with a parser generator, to get rid of the need to write a '#' to tell the assembler something it should know: a difference between two addresses is a constant;
    - add an additional step to automatically change JR into JP if the distance is too far;
    - cleanup the symbol table to implement the  [GLOBAL](#10_14)  suggestion: declare a symbol  [GLOBAL](#10_14)  and it is  [PUBLIC](#10_26)  if defined, or  [EXTERN](#10_12)  otherwise
    - implement macros inside the assembler
    - add high level constructs ( [IF](#10_15)  flag / ELSE / ENDIF, DO WHILE flag, ...)
    - add a rule based optimizer based on RAGEL as a state machine generator
    - BUG_0038: library modules not loaded in sequence: The library modules loaded to the linked binary file should respect the order given on the command line.
    - generate .err files with errors
    - show source line and syntax error location 
    - Manage libraries
    - Link object files and libraries
    - Split object files in modules, link each module separately
    - :: to define public symbol
    - ## to declare external symbol
    - #include
    - #define
    - #macro
	- Implement recursive includes in Coco/R parser/scanner
	- Separate standard  [Z80](#7)  assembly from extensions; add macro files for extensions.
	- Port to C++
	- Parse command line
	- Input source
	- Preprocess
	- Lexing
	- Parsing
	- Symbol Table
	- Object Files
	- Assembling 
	- Linking
	- List file
	- allow EQU as synonym to  [DEFC](#10_6) 
	- finish the split between front-end and back-end;
	- implement an expression parser with a parser generator, to get rid of
	  the need to write a '#' to tell the assembler something it should know:
	  a difference between two addresses is a constant;
	- add an additional step to automatically change JR into JP if the
	  distance is too far;
	- implement macros inside the assembler
	- add high level constructs ( [IF](#10_15)  flag / ELSE / ENDIF, 
	  DO WHILE flag, ...)
	- add a rule based optimizer based on RAGEL as a state machine generator

	- Errors are only output on stderr, *.err files are not created.
	  *.err files are a leftover from operating systems that could not
	  redirect standard error.

	  Fatal errors example:  
	  x.cc:1:18: fatal error: nofile: No such file or directory  
		\#include "nofile"  
		------------------^  
	  compilation terminated.

	  Non-fatal errors example:  
	  x.cc:1:7: error: expected initializer before 'b'  
		int a b  
		-------^ 

	- Simplify generation of cpu test files, remove z80pack



----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=13></a>

## 13. References

- [The Telemark Assembler](http://www.cpcalive.com/docs/TASMMAN.HTM)


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=14></a>

## 14. Copyright

The original z80asm module assembler was written by Gunther Strube. 
It was converted from QL SuperBASIC version 0.956, initially ported to Lattice C,
and then to C68 on QDOS.

It has been maintained since 2011 by Paulo Custodio.

Copyright (C) Gunther Strube, InterLogic 1993-99  
Copyright (C) Paulo Custodio, 2011-2020


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=15></a>

## 15. License

Artistic License 2.0 (http://www.perlfoundation.org/artisticlicense2_0)

<a id=keywords></a>


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=16></a>

## 16. Keywords
 [-C](#6_2_15) 
 [-DVARIABLE](#3_5) 
 [-IDIR](#3_4_1) 
 [-IXIY](#3_6_2) 
 [-LDIR](#3_4_2) 
 [-M](#6_2_2) 
 [-R](#6_2_8) 
 [-RCMX000](#6_2_13) 
 [-a](#6_2_5) 
 [-atoctal](#3_2_1) 
 [-b](#6_2_4) 
 [-d](#6_2_3) 
 [-debug](#3_6_4) 
 [-dotdirective](#3_2_2) 
 [-e](#6_2_1) 
 [-g](#3_7_4) 
 [-h](#3_1_2) 
 [-hashhex](#3_2_3) 
 [-i](#6_2_10) 
 [-l](#3_7_2) 
 [-labelcol1](#3_2_4) 
 [-m](#3_7_3) 
 [-mCPU](#3_6_1) 
 [-noprec](#3_3_1) 
 [-o](#6_2_6) 
 [-opt](#3_6_3) 
 [-plus](#6_2_14) 
 [-r](#6_2_7) 
 [-s](#3_7_1) 
 [-t](#6_2_12) 
 [-ucase](#3_2_5) 
 [-v](#3_1_3) 
 [-x](#6_2_11) 
 [BINARY](#10_1) 
 [CALL](#10_2) 
 [DEFB](#10_3) 
 [DEFC](#10_6) 
 [DEFGROUP](#10_8) 
 [DEFINE](#10_9) 
 [DEFL](#10_5) 
 [DEFM](#10_7) 
 [DEFS](#10_10) 
 [DEFVARS](#10_11) 
 [DEFW](#10_4) 
 [EXTERN](#10_12) 
 [FPP](#10_13) 
 [GLOBAL](#10_14) 
 [IF](#10_15) 
 [IFDEF](#10_16) 
 [IFNDEF](#10_17) 
 [INCLUDE](#10_18) 
 [INVOKE](#10_19) 
 [LIB](#10_20) 
 [LINE](#10_21) 
 [LSTOFF](#10_22) 
 [LSTON](#10_23) 
 [MODULE](#10_24) 
 [ORG](#10_25) 
 [PUBLIC](#10_26) 
 [XDEF](#10_27) 
 [XLIB](#10_28) 
 [XREF](#10_29) 
 [Z80](#7) 
 [Z88](#6_5) 
<a id=index></a>


----

[(top)](#top) [(keywords)](#keywords) [(index)](#index)
<a id=17></a>

## 17. Index
- [1.](#1) Usage ...
  - [1.1.](#1_1) ... as preprocessor
  - [1.2.](#1_2) ... as assembler
  - [1.3.](#1_3) ... as linker
  - [1.4.](#1_4) ... as librarian
- [2.](#2) Environment Variables
- [3.](#3) Options
  - [3.1.](#3_1) Help Options
    - [3.1.1.](#3_1_1) no arguments (show usage)
    - [3.1.2.](#3_1_2)  [-h](#3_1_2) , -? (show manual)
    - [3.1.3.](#3_1_3)  [-v](#3_1_3)  (show progress)
  - [3.2.](#3_2) Preprocessor options
    - [3.2.1.](#3_2_1)  [-atoctal](#3_2_1)  (at is octal prefix)
    - [3.2.2.](#3_2_2)  [-dotdirective](#3_2_2)  (period is directive prefix)
    - [3.2.3.](#3_2_3)  [-hashhex](#3_2_3)  (hash is hex prefix)
    - [3.2.4.](#3_2_4)  [-labelcol1](#3_2_4)  (labels at column 1)
    - [3.2.5.](#3_2_5)  [-ucase](#3_2_5)  (upper case)
  - [3.3.](#3_3) Assembly options
    - [3.3.1.](#3_3_1)  [-noprec](#3_3_1)  (no precedence in expression evaluation)
  - [3.4.](#3_4) Environment Options
    - [3.4.1.](#3_4_1)  [-IDIR](#3_4_1)  (directory for source files)
    - [3.4.2.](#3_4_2)  [-LDIR](#3_4_2)  (directory for library)
  - [3.5.](#3_5)  [-DVARIABLE](#3_5)  [= value], --define=VARIABLE [= value] (define a static symbol)
  - [3.6.](#3_6) Code Generation Options
    - [3.6.1.](#3_6_1)  [-mCPU](#3_6_1)  (select CPU)
    - [3.6.2.](#3_6_2)  [-IXIY](#3_6_2)  (swap IX and IY)
    - [3.6.3.](#3_6_3)  [-opt](#3_6_3) -speed (optimise for speed)
    - [3.6.4.](#3_6_4)  [-debug](#3_6_4)  (debug information)
  - [3.7.](#3_7) Output File Options
    - [3.7.1.](#3_7_1)  [-s](#3_7_1)  (create symbol table)
    - [3.7.2.](#3_7_2)  [-l](#3_7_2)  (create list file)
    - [3.7.3.](#3_7_3)  [-m](#3_7_3)  (create map file)
    - [3.7.4.](#3_7_4)  [-g](#3_7_4)  (global definitions file)
- [4.](#4) Input Files
  - [4.1.](#4_1) Source File Format
  - [4.2.](#4_2) Comments
  - [4.3.](#4_3) Symbols
  - [4.4.](#4_4) Labels
  - [4.5.](#4_5) Numbers
    - [4.5.1.](#4_5_1) Decimal
    - [4.5.2.](#4_5_2) Hexadecimal
    - [4.5.3.](#4_5_3) Octal
    - [4.5.4.](#4_5_4) Binary
    - [4.5.5.](#4_5_5) Bitmaps
  - [4.6.](#4_6) Keywords
  - [4.7.](#4_7) Directives and Opcodes
- [5.](#5) Object File Format
  - [5.1.](#5_1) Object Files
  - [5.2.](#5_2) Library File Format
  - [5.3.](#5_3) Format History
- [6.](#6) z80asm Syntax
  - [6.1.](#6_1) Command line
  - [6.2.](#6_2) Command line options
    - [6.2.1.](#6_2_1)  [-e](#6_2_1) \<ext\> : Use alternative source file extension
    - [6.2.2.](#6_2_2)  [-M](#6_2_2) \<ext\> : Use alternative object file extension
    - [6.2.3.](#6_2_3)  [-d](#6_2_3)  : Assemble only updated files
    - [6.2.4.](#6_2_4)  [-b](#6_2_4)  : Link/relocate object files
    - [6.2.5.](#6_2_5)  [-a](#6_2_5)  : Combine  [-d](#6_2_3)  and  [-b](#6_2_4) 
    - [6.2.6.](#6_2_6)  [-o](#6_2_6) \<binary-filename\> : Binary filename
    - [6.2.7.](#6_2_7)  [-r](#6_2_7) \<hex-address\> : Re-define the  [ORG](#10_25)  relocation address
    - [6.2.8.](#6_2_8)  [-R](#6_2_8)  : Generate address independent code
    - [6.2.9.](#6_2_9) @\<project-file\> :1.3.16. Using a project file
    - [6.2.10.](#6_2_10)  [-i](#6_2_10) \<library-file\> : Include library modules during linking/relocation
    - [6.2.11.](#6_2_11)  [-x](#6_2_11)  : Create a library
    - [6.2.12.](#6_2_12)  [-t](#6_2_12) \<number\> : Define tabulator distance for text output files
    - [6.2.13.](#6_2_13)  [-RCMX000](#6_2_13)  : Support the RCM2000/RCM3000 series of  [Z80](#7) -like CPU's
    - [6.2.14.](#6_2_14)  [-plus](#6_2_14)  : Support for the Ti83Plus
    - [6.2.15.](#6_2_15)  [-C](#6_2_15)  : Enable  [LINE](#10_21)  directive
  - [6.3.](#6_3) The  [Z88](#6_5)  operating system definition files
  - [6.4.](#6_4) The supplied standard library  [Z80](#7)  source files
  - [6.5.](#6_5)  [Z88](#6_5)  module assembler application source
  - [6.6.](#6_6) File based compilation
  - [6.7.](#6_7) Modular source file design
  - [6.8.](#6_8) Scope of symbols in source modules
  - [6.9.](#6_9) Using arithmetic and relational expressions
  - [6.10.](#6_10) Free format of assembler source files
  - [6.11.](#6_11) Specification of filenames
  - [6.12.](#6_12) Including other source files into the current source file
  - [6.13.](#6_13) Conditional assembly in source file modules
  - [6.14.](#6_14) Undocumented  [Z80](#7)  instruction code generation
  - [6.15.](#6_15) Object file generation
  - [6.16.](#6_16) Transfer of object files across platforms
  - [6.17.](#6_17) Date stamp controlled assembly
  - [6.18.](#6_18) Listing files
  - [6.19.](#6_19) Symbol information
  - [6.20.](#6_20) Linking and relocation of object modules into executable  [Z80](#7)  machine code
  - [6.21.](#6_21) Address map files
  - [6.22.](#6_22) Symbol address definition files
  - [6.23.](#6_23) Error files
  - [6.24.](#6_24) Creating and using object file libraries for standard routines
- [7.](#7)  [Z80](#7)  module assembler file types
  - [7.1.](#7_1) The assembler file types and their extension names
  - [7.2.](#7_2) The file name extension identifier
  - [7.3.](#7_3) File types
    - [7.3.1.](#7_3_1) The source file extension, asm
    - [7.3.2.](#7_3_2) The object file extension, obj
    - [7.3.3.](#7_3_3) The error file extension, err
    - [7.3.4.](#7_3_4) The listing file extension, lst
    - [7.3.5.](#7_3_5) The symbol file extension, sym
    - [7.3.6.](#7_3_6) The executable file extension, bin
    - [7.3.7.](#7_3_7) The address map file extension, map
    - [7.3.8.](#7_3_8) The definition file extension, def
    - [7.3.9.](#7_3_9) The library file extension, lib
- [8.](#8) Compiling files
  - [8.1.](#8_1) The assembler compiling process
    - [8.1.1.](#8_1_1) Stage 1, parsing and code generation of all source files, object file generation
    - [8.1.2.](#8_1_2) Stage 2, linking object files and library modules, producing executable code
  - [8.2.](#8_2) File names
  - [8.3.](#8_3) Portability of assembler file names
  - [8.4.](#8_4) Source file structure
  - [8.5.](#8_5) Using local, global and external symbols
  - [8.6.](#8_6) Defining symbol names
  - [8.7.](#8_7) Comments in source files
  - [8.8.](#8_8) Defining symbolic address labels
  - [8.9.](#8_9) Writing  [Z80](#7)  mnemonic instructions
  - [8.10.](#8_10) Optional  [Z80](#7)  mnemonic instruction syntax
  - [8.11.](#8_11) The undocumented  [Z80](#7)  instructions
  - [8.12.](#8_12) Referencing library routines
  - [8.13.](#8_13) Creating/updating libraries
  - [8.14.](#8_14) Referencing routines in other compiled projects
- [9.](#9) Using expressions
  - [9.1.](#9_1) Constant identifiers
  - [9.2.](#9_2) Arithmetic operators
  - [9.3.](#9_3) Relational operators
  - [9.4.](#9_4) The ASMPC standard function
  - [9.5.](#9_5) Symbol identifiers in expressions
- [10.](#10) Directive reference
  - [10.1.](#10_1)  [BINARY](#10_1)  "filename"
  - [10.2.](#10_2)  [CALL](#10_2) \_OZ \<expression\>
  - [10.3.](#10_3)  [DEFB](#10_3)  \<8-bit expr\>,{\<8-bit expr\>} (-128; 255)
  - [10.4.](#10_4)  [DEFW](#10_4)  \<16-bit expr\>,{\<16-bit expr\>} (-32768; 65535)
  - [10.5.](#10_5)  [DEFL](#10_5)  \<32-bit expr\>,{\<32-bit expr\>} (-2147483647; 4294967295)
  - [10.6.](#10_6)  [DEFC](#10_6)  name=\<32-bit expression\>{, name=\<32-bit expression\>}
  - [10.7.](#10_7)  [DEFM](#10_7)  \<string expression\>|\<8-bit expr\>,...
  - [10.8.](#10_8)  [DEFGROUP](#10_8)  '{' name {',' name \['=' \<8-bit expression\>\]} '}'
  - [10.9.](#10_9)  [DEFINE](#10_9)  name,{name}
  - [10.10.](#10_10)  [DEFS](#10_10)  \<size\>{, \<fill-byte\>}
  - [10.11.](#10_11)  [DEFVARS](#10_11)  \<16-bit expression\> '{' \[\<name\>\] \[\<storage\_size\> \<size\_multiplier\>\] '}'
  - [10.12.](#10_12)  [EXTERN](#10_12)  name {, name}
  - [10.13.](#10_13)  [FPP](#10_13)  \<8-bit expression\>
  - [10.14.](#10_14)  [GLOBAL](#10_14)  name {, name}
  - [10.15.](#10_15)  [IF](#10_15)  \<logical expression\> ... \[ELSE\] ... ENDIF
  - [10.16.](#10_16)  [IFDEF](#10_16)  \<name\> ... \[ELSE\] ... ENDIF
  - [10.17.](#10_17)  [IFNDEF](#10_17)  \<name\> ... \[ELSE\] ... ENDIF
  - [10.18.](#10_18)  [INCLUDE](#10_18)  "filename"
  - [10.19.](#10_19)  [INVOKE](#10_19)  \<16-bit expression\>
  - [10.20.](#10_20)  [LIB](#10_20)  name {,name}
  - [10.21.](#10_21)  [LINE](#10_21)  \<32-bit expr\> \[ , "file-name" \]
  - [10.22.](#10_22)  [LSTOFF](#10_22) 
  - [10.23.](#10_23)  [LSTON](#10_23) 
  - [10.24.](#10_24)  [MODULE](#10_24)  name
  - [10.25.](#10_25)  [ORG](#10_25)  \<16-bit expression\>
  - [10.26.](#10_26)  [PUBLIC](#10_26)  name {, name}
  - [10.27.](#10_27)  [XDEF](#10_27)  name {, name}
  - [10.28.](#10_28)  [XLIB](#10_28)  name
  - [10.29.](#10_29)  [XREF](#10_29)  name {, name}
- [11.](#11) Run time error messages
- [12.](#12) Backlog
- [13.](#13) References
- [14.](#14) Copyright
- [15.](#15) License
- [16.](#16) Keywords
- [17.](#17) Index