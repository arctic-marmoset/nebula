module core (
    input logic clk_i,
    input logic rst_n_i
);

  import types::*;

  word_t pc_o;
  pc pc_inst (
      .clk_i  (clk_i),
      .rst_n_i(rst_n_i),
      .pc_o   (pc_o)
  );

  word_t fetch_pc_o;
  word_t fetch_instr_o;
  fetch fetch_inst (
      .clk_i  (clk_i),
      .rst_n_i(rst_n_i),
      .pc_i   (pc_o),
      .pc_o   (fetch_pc_o),
      .instr_o(fetch_instr_o)
  );

  word_t decode_pc_i;
  word_t decode_instr_i;
  always_ff @(posedge clk_i) begin
    if (rst_n_i == 0) begin
      decode_pc_i    <= 0;
      decode_instr_i <= 0;
    end else begin
      decode_pc_i    <= fetch_pc_o;
      decode_instr_i <= fetch_instr_o;
    end
  end

  decode decode_inst (
      .clk_i  (clk_i),
      .rst_n_i(rst_n_i),
      .pc_i   (decode_pc_i),
      .instr_i(decode_instr_i)
  );

endmodule
