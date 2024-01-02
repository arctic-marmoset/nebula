`ifndef COMMON_SVH
`define COMMON_SVH

`define RESET_ADDRESS 32'h00001000

typedef struct packed {
  logic [31:0] address;
} icache_read_t;

`endif
