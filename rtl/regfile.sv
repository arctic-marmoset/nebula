module regfile (
    input  logic            clk_i,
    input  logic            rst_n_i,
    input  logic      [4:0] addr_rs1_i,
    input  logic      [4:0] addr_rs2_i,
    output types::x_t       data_rs1_o,
    output types::x_t       data_rs2_o
);

  import types::x_t;

  x_t x[32];
  always_ff @(posedge clk_i) begin
    if (rst_n_i == 0) begin
      x[0] <= 0;
    end else begin
      data_rs1_o <= x[addr_rs1_i];
      data_rs2_o <= x[addr_rs2_i];
    end
  end

  always_ff @(posedge clk_i) begin
    if (rst_n_i == 1) begin
      assert (x[0] == 0)
      else $fatal(1, "reg x0 (zero) is not 0!");
    end
  end

endmodule
