`ifndef TEST_SIZE
`define TEST_SIZE 0
`endif

`ifndef TEST_PATH
`define TEST_PATH "INVALID_PATH"
`endif

module fetch (
    input  logic          clk_i,
    input  logic          rst_n_i,
    input  nebula::word_t pc_i,

    output nebula::word_t pc_o,
    output nebula::word_t instr_o
);

  import addressing::BaseAddress;
  import nebula::word_t;

  logic [7:0] instr_bytes[`TEST_SIZE];
  initial begin
    $readmemh(`TEST_PATH, instr_bytes, 0, `TEST_SIZE - 1);
  end

  logic [31:0] address = pc_i - BaseAddress;
`ifndef NDEBUG
  always_ff @(posedge clk_i) begin
    if (rst_n_i == 1) begin
      assert (pc_i >= BaseAddress) else $fatal(1, "pc is less than base address!");
    end
  end
`endif

  logic [31:0] instr = {
    instr_bytes[address+3],
    instr_bytes[address+2],
    instr_bytes[address+1],
    instr_bytes[address]
  };

  assign pc_o = pc_i;
  assign instr_o = instr;

`ifndef NDEBUG
  decode fetch_decode_dbg (
    .clk_i  (clk_i),
    .rst_n_i(rst_n_i),
    .pc_i   (pc_i),
    .instr_i(instr)
  );
`endif

endmodule
