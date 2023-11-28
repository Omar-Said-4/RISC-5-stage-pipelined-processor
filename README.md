# RISC-5-stage-pipelined-processor

## 📝 Table of Contents

- [About](#About)
- [Built With](#Built-With)
- [Design](#Design)
- [ISA](#ISA)
- [Input signals](#Input-signals)
- [Control signals](#Control-signals)
- [Contributors](#Contributors)

# 📑 About

A RISC-like, five-stage pipeline processor implemented using VHDL, is based on the Reduced Instruction Set Computer (RISC) architecture, The five stages of the pipeline include instruction fetch, instruction decode, execution, memory access, and write back. Each stage takes a single clock cycle to complete and the instructions are executed in parallel. This allows for faster execution of instructions compared to other architectures.

## ⛏️Built with
- VHDL

## ISA

| Category       | Instruction | Opcode (Category) | Immediate value | Destination | Source1     | Source2     | function  |
| -------------- | ----------- | ----------------- | --------------- | ------------| ----------- | ----------- | --------- |
| ALU            | NOT         | 00                | 0               | UUU         | UUU         | DDD         | 0000      |
| ALU            | NEG         | 00                | 0               | UUU         | UUU         | DDD         | 0001      |
| ALU            | INC         | 00                | 0               | UUU         | UUU         | DDD         | 0010      |
| ALU            | DEC         | 00                | 0               | UUU         | UUU         | DDD         | 0011      |
| ALU            | ADD         | 00                | 0               | UUU         | UUU         | UUU         | 0100      |
| ALU            | ADDI        | 00                | 1               | UUU         | UUU         | DDD         | 0101      |
| ALU            | SUB         | 00                | 0               | UUU         | UUU         | UUU         | 0110      |
| ALU            | AND         | 00                | 0               | UUU         | UUU         | UUU         | 0111      |
| ALU            | XOR         | 00                | 0               | UUU         | UUU         | UUU         | 1000      |
| ALU            | OR          | 00                | 0               | UUU         | UUU         | UUU         | 1001      |
| ALU            | CMP         | 00                | 0               | DDD         | UUU         | UUU         | 1010      |
| ALU            | BITSET      | 00                | 1               | UUU         | DDD         | DDD         | 1011      |
| ALU            | RCR         | 00                | 1               | UUU         | UUU         | DDD         | 1100      |
| ALU            | RCL         | 00                | 1               | UUU         | UUU         | DDD         | 1101      |
| ALU            | SWAP        | 00                | 0               | UUU         | UUU         | DDD         | 1110      |
| ALU            | LDM         | 00                | 1               | UUU         | DDD         | DDD         | 1111      |
| ----           | NOP         | 11                | 1               | 111         | 111         | 111         | 1111      |

| Category       | Instruction | Opcode (Category) | Effective address | Destination | Source   | Function | EA Low  |
| -------------- | ----------- | ----------------- | ----------------- | ------------| -------- | -------  | ------- |
| MEM            | PUSH        | 01                | 0                 | UUU         | DDD      | 000      | UUUU    | 
| MEM            | POP         | 01                | 0                 | UUU         | DDD      | 001      | UUUU    | 
| MEM            | STD         | 01                | 1                 | UUU         | DDD      | 010      | UUUU    | 
| MEM            | LDD         | 01                | 1                 | DDD         | UUU      | 011      | UUUU    | 
| MEM            | PROTECT     | 01                | 0                 | DDD         | UUU      | 100      | UUUU    | 
| MEM            | FREE        | 01                | 0                 | DDD         | UUU      | 110      | UUUU    | 



| Category       | Instruction | Opcode (Category) |Reserved | Destination   | Source   | Function | Reserved  |
| -------------- | ----------  | ----------------- |-------- |-------------  | -------- | -------- |---------- |
| PORT           | IN          | 10                |    X    | UUU           | DDD      | XX0      | XXXX      |
| PORT           | OUT         | 10                |    X    | DDD           | UUU      | XX1      | XXXX      |

| Category       | Instruction   | Opcode (Category) |Reserved  |Destination   |Reserved   |Function  |Reserved |
| -------------- | ----------    | ----------------- |--------- |------------- |---------- | -------  |-------- |
|  JUMP          | CALL          | 11                |   X      |UUU           |XXX        | 000      |XXXX     |
|  JUMP          | JMP           | 11                |   X      |UUU           |XXX        | 110      |XXXX     |
|  JUMP          | JZ            | 11                |   X      |UUU           |XXX        | 010      |XXXX     |
|  JUMP          | RET           | 11                |   X      |UUU           |XXX        | 101      |XXXX     |
|  JUMP          | RTI           | 11                |   X      |UUU           |XXX        | 001      |XXXX     |




## Input signals

| Signal    |
| --------- |
| Interrupt |
| reset     |



## Control signals
| Operation | MR | MW | IOR | IOW | WB1 | WB2 |  Stack operation | Push/Pop  | JUMP | CALL | RSTCTRL | ALU  | PROTECT | FREE | 
| ----------|--- | ---|-----|---- | ----|-----|------------------|-----------|------| -----|-------- |------| ------- | ---- |
| NOP       | 0  | 0  |  0  |  0  | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| NEG       | 0  | 0  |  0  |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| INC       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| DEC       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| ADD       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| ADDI      | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| SUB       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| AND       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| XOR       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| OR        | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| CMP       | 0  | 0  |   0 |   0 | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| BITSET    | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| RCR       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| RCL       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| SWAP      | 0  | 0  |   0 |   0 | 1   | 1   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| LDM       | 0  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 1    |  0      | 0    |
| PUSH      | 0  | 1  |   0 |   0 | 0   | 0   | 1                | 1         | 0    | 0    | 0       | 0    |  0      | 0    |
| POP       | 1  | 0  |   0 |   0 | 1   | 0   | 1                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| LDD       | 1  | 0  |   0 |   0 | 1   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| STD       | 0  | 1  |   0 |   0 | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| PROTECT   | 0  | 0  |   0 |   0 | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  1      | 0    |
| FREE      | 0  | 0  |   0 |   0 | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  0      | 1    |
| IN        | 0  | 0  |   1 |   0 | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| OUT       | 0  | 0  |   0 |   1 | 0   | 0   | 0                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| CALL      | 0  | 1  |   0 |   0 | 0   | 0   | 1                | 1         | 0    | 1    | 0       | 0    |  0      | 0    |
| JUMP      | 0  | 0  |   0 |   0 | 0   | 0   | 0                | 0         | 1    | 0    | 0       | 0    |  0      | 0    |
| JZ        | 0  | 0  |   0 |   0 | 0   | 0   | 0                | 0         | 1    | 0    | 0       | 0    |  0      | 0    |
| RET       | 1  | 0  |   0 |   0 | 0   | 0   | 1                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |
| RTI       | 1  | 0  |   0 |   0 | 0   | 0   | 1                | 0         | 0    | 0    | 0       | 0    |  0      | 0    |



