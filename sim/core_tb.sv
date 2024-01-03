`include "common.svh"
`include "instructions.vh"

`ifndef TEST_SIZE
`define TEST_SIZE 0
`endif

`ifndef TEST_PATH
`define TEST_PATH "INVALID_PATH"
`endif

module core_tb;
  logic       clk;
  logic       rst;

  logic [7:0] instr_bytes[`TEST_SIZE];
  initial begin
    $readmemh(`TEST_PATH, instr_bytes, 0, `TEST_SIZE - 1);
  end

  initial begin
    $dumpfile("nebula.fst");
    $dumpvars;
  end

  clockgen clockgen_inst (
    .clk_o(clk),
    .rst_o(rst)
  );

  wire [31:0] icache_address;
  wire [31:0] address = icache_address - `RESET_ADDRESS;
  wire [31:0] icache_data = {
    instr_bytes[address+3],
    instr_bytes[address+2],
    instr_bytes[address+1],
    instr_bytes[address]
  };

  core dut (
    .clk_i(clk),
    .rst_i(rst),

    .icache_read_data_i   (icache_data),
    .icache_read_address_o(icache_address)
  );

  always_ff @(posedge clk) begin
    if (!rst) begin
      if (dut.mw_instruction_q == INSTRUCTION_WFI) begin
        $finish;
      end
    end
  end
endmodule
