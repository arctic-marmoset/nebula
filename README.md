# Nebula

A RISC-V RV32I core written in SystemVerilog for learning purposes.

## Requirements

### Core

- Verilator

### Testing

- RISC-V RV64 GCC toolchain[^1]
- [od](https://en.wikipedia.org/wiki/Od_(Unix)) (for hexdumping test binaries so
  they can be read with `$readmemh`)

[^1]: `test/Makefile` currently has the toolchain prefix hard-coded to be
`riscv64-elf-` as this is what it is on Arch Linux. Other distros may have
different prefixes, so the Makefile should be modified accordingly.
