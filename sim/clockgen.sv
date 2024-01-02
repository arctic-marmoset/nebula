module clockgen (
  output logic clk_o,
  output logic rst_o
);
  localparam unsigned ResetCycleCount = 2;
  localparam unsigned MaxCycleCount = 16 * 1024;

  localparam unsigned ResetToggleCount = ResetCycleCount * 2;

  initial begin
    clk_o = 0;
    rst_o = 1;
  end

  initial begin
    #ResetToggleCount;
    rst_o = 0;
  end

  /* verilator lint_off BLKSEQ */
  always #1 clk_o = ~clk_o;
  /* verilator lint_on BLKSEQ */

  int unsigned cycle_count = 0;
  always_ff @(posedge clk_o) begin
    cycle_count <= cycle_count + 1;
    if (cycle_count == MaxCycleCount) begin
      $finish;
    end
  end
endmodule
