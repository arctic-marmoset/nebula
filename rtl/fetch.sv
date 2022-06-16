`ifndef TEST_SIZE
`define TEST_SIZE 0
`endif

`ifndef TEST_PATH
`define TEST_PATH "INVALID_PATH"
`endif

module fetch (
    input  logic         clk_i,
    input  logic         rst_n_i,
    input  types::word_t pc_i,
    output types::word_t instr_o
);

  byte instr_o_bytes[`TEST_SIZE];
  initial begin
    $readmemh(`TEST_PATH, instr_o_bytes, 0, `TEST_SIZE - 1);
  end

  always_ff @(posedge clk_i) begin
    if (rst_n_i == 0) begin
      instr_o <= 0;
    end else begin
      instr_o <= {instr_o_bytes[pc_i+3], instr_o_bytes[pc_i+2], instr_o_bytes[pc_i+1], instr_o_bytes[pc_i]};
    end
  end

endmodule
