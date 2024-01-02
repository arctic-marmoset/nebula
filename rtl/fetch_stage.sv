module fetch_stage (
  input  logic [31:0] pc_i,
  output logic [31:0] instruction_o,

  input  logic [31:0] icache_read_data_i,
  output logic [31:0] icache_read_address_o
);
  assign icache_read_address_o = pc_i;
  assign instruction_o = icache_read_data_i;
endmodule
