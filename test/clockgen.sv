`timescale 1ps / 1ps

module clockgen (
    output logic clk_o,
    output logic rst_n_o
);

  localparam bit [31:0] ResetCycleCount = 2;

  localparam bit [31:0] MaxCycleCount = 16 * 1024;

  initial begin
    clk_o   = 0;
    rst_n_o = 0;
  end

  initial begin
    #ResetCycleCount;
    rst_n_o = 1;
  end

  always #1 clk_o = ~clk_o;

  bit [31:0] cycle_count = 0;
  always_ff @(posedge clk_o) begin
    cycle_count <= cycle_count + 1;
    if (cycle_count == MaxCycleCount) begin
      $finish;
    end
  end

endmodule
