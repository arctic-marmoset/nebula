`ifndef REGISTER_FILE_SVH
`define REGISTER_FILE_SVH

typedef struct packed {
  logic        enable;
  logic [4:0]  address;
  logic [31:0] data;
} register_file_write_t;

`endif
