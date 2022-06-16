`timescale 1ps / 1ps

module clockgen (
    output logic clk,
    output logic rst_n
);

  localparam bit [31:0] ResetCycleCount = 2;

  localparam bit [31:0] MaxCycleCount = 1 * 1024 * 1024;

  initial begin
    clk   = 0;
    rst_n = 0;
  end

  initial begin
    #ResetCycleCount;
    rst_n = 1;
  end

  always #1 clk = ~clk;

  bit [31:0] cycle_count = 0;
  always_ff @(posedge clk) begin
    cycle_count <= cycle_count + 1;
    if (cycle_count == MaxCycleCount) begin
      $finish;
    end
  end

endmodule
