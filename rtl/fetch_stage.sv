module fetch_stage (
  // Interface
  input  logic [31:0] pc_i,
  output logic [31:0] instruction_o,
  // Implementation Detail Signals
  input  logic [31:0] icache_read_data_i,
  output logic [31:0] icache_read_address_o
);
  assign icache_read_address_o = pc_i;
  assign instruction_o         = icache_read_data_i;
endmodule
