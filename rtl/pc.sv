module pc (
    input  logic         clk_i,
    input  logic         rst_n_i,
    output types::word_t pc_o
);

  always_ff @(posedge clk_i) begin
    if (rst_n_i == 0) begin
      pc_o <= 0;
    end else begin
      pc_o <= pc_o + 4;
    end
  end

endmodule
