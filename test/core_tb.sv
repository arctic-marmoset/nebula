module core_tb;

  logic clk;
  logic rst_n;

  initial begin
    $dumpfile("nebula.vcd");
    $dumpvars;
  end

  clockgen clockgen_inst (
      .clk_o  (clk),
      .rst_n_o(rst_n)
  );

  core core_inst (
      .clk_i  (clk),
      .rst_n_i(rst_n)
  );

endmodule
