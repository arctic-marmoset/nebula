`ifndef COMMON_SVH
`define COMMON_SVH

// FIXME: Maybe automatically keep this in sync with linker script.
`ifndef RESET_ADDRESS
`define RESET_ADDRESS 32'h00001000
`endif
`ifndef RAM_ADDRESS
`define RAM_ADDRESS   32'h80000000
`endif

typedef struct packed {
  logic [31:0] address;
} icache_read_t;

`endif
