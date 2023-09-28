module regfile (
    input  logic             clk_i,
    input  logic             rst_n_i,
    input  logic      [4:0]  addr_rs1_i,
    input  logic      [4:0]  addr_rs2_i,
    output nebula::x_t       data_rs1_o,
    output nebula::x_t       data_rs2_o
);

  import nebula::x_t;

  localparam unsigned RegisterCount = 32;

  x_t x[RegisterCount];
  always_ff @(posedge clk_i) begin
    if (rst_n_i == 0) begin
      for (int i = 0; i < RegisterCount; ++i) begin
        x[i] <= 0;
      end
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
