`ifndef REGISTER_FILE_SVH
`define REGISTER_FILE_SVH

typedef enum logic [4:0] {
  REG_ZERO,
  REG_RA,
  REG_SP,
  REG_GP,
  REG_TP,
  REG_T0,
  REG_T1,
  REG_T2,
  REG_S0,
  REG_S1,
  REG_A0,
  REG_A1,
  REG_A2,
  REG_A3,
  REG_A4,
  REG_A5,
  REG_A6,
  REG_A7,
  REG_S2,
  REG_S3,
  REG_S4,
  REG_S5,
  REG_S6,
  REG_S7,
  REG_S8,
  REG_S9,
  REG_S10,
  REG_S11,
  REG_T3,
  REG_T4,
  REG_T5,
  REG_T6
} register_t;

// Packed structs are difficult to debug in GTKWave.
`ifndef SYNTHESIS
`define NEBULA_SYNTHESIS_PACKED
`else
`define NEBULA_SYNTHESIS_PACKED packed
`endif

typedef struct `NEBULA_SYNTHESIS_PACKED {
  logic        enable;
  register_t   address;
  logic [31:0] data;
} register_file_write_t;

`undef NEBULA_SYNTHESIS_PACKED

`endif
