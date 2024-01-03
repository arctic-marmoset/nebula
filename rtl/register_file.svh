`ifndef REGISTER_FILE_SVH
`define REGISTER_FILE_SVH

// Packed structs are difficult to debug in GTKWave.
`ifndef SYNTHESIS
`define NEBULA_SYNTHESIS_PACKED
`else
`define NEBULA_SYNTHESIS_PACKED packed
`endif

typedef struct `NEBULA_SYNTHESIS_PACKED {
  logic        enable;
  logic [4:0]  address;
  logic [31:0] data;
} register_file_write_t;

`undef NEBULA_SYNTHESIS_PACKED

`endif
