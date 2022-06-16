module core (
    input logic clk,
    input logic rst_n
);

  import types::*;

  word_t pc;
  pc pc_inst (
      .clk_i  (clk),
      .rst_n_i(rst_n),
      .pc_o   (pc)
  );

  word_t instr;
  fetch fetch_inst (
      .clk_i  (clk),
      .rst_n_i(rst_n),
      .pc_i   (pc),
      .instr_o(instr)
  );

  word_t data_rs1;
  word_t data_rs2;
  regfile regfile_inst (
      .clk_i     (clk),
      .rst_n_i   (rst_n),
      .addr_rs1_i(5'd0),
      .addr_rs2_i(5'd0),
      .data_rs1_o(data_rs1),
      .data_rs2_o(data_rs2)
  );

endmodule
