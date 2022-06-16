module core_tb;

  logic clk;
  logic rst_n;

  initial begin
    $dumpfile("nebula.vcd");
    $dumpvars;
  end

  clockgen clockgen_inst (
      .clk  (clk),
      .rst_n(rst_n)
  );

  core core_inst (
      .clk  (clk),
      .rst_n(rst_n)
  );

endmodule
