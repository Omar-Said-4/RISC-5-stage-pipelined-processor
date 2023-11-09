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

| Category       | Instruction | Opcode (Category) | Opcode (Number) | Source | Destination | Immediate value |
| -------------- | ----------- | ----------------- | --------------- | ------ | ----------- | --------------- |
| ALU            | NOP         | 00                | 000000          | UUU    | UUUU        | U               |
| -------------- | ----------- | ----------------- | --------------- | ------ | ----------- | --------------- |



## Input signals

| Signal    |
| --------- |
| Interrupt |
| reset     |



## Control signals
| Operation | ALU function | Branch | Data read | Data write | DMR | DMW | IOE | IOW | IOR | Stack operation | Push/Pop | pass_immediate | write_sp | rti | ret | call | branch_type|
| --------- | ------------ | ------ | --------- | ---------- | --- | --- | --- | --- | --- | --------------- | -------- | -------------- | -------- | --- | --- | ---- | ---------- |
| NOP         | 0000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| --------- | ------------ | ------ | --------- | ---------- | --- | --- | --- | --- | --- | --------------- | -------- | -------------- | -------- | --- | --- | ---- | ---------- |


