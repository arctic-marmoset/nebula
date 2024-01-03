`include "alu_operand.svh"
`include "common.svh"
`include "register_file.svh"
`include "writeback.svh"

module core #(
  parameter unsigned ResetAddress = `RESET_ADDRESS
) (
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic [31:0] icache_read_data_i,
  output logic [31:0] icache_read_address_o
);
`include "instructions.vh"

  localparam unsigned RegFileReadPortCount = 2;
  localparam unsigned RegFileWritePortCount = 1;

  logic [31:0] pc_d;
  logic [31:0] pc_q;
  wire  [31:0] pc_next_sequential = pc_q + 'd4;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      pc_q <= ResetAddress;
    end else begin
      pc_q <= pc_d;
    end
  end

  wire decode_jump_target_valid;
  wire execute_branch_target_valid;
  wire kill_fetch;
  wire kill_decode;
  hazard_detection_unit hazard (
    .decode_jump_target_valid_i   (decode_jump_target_valid),
    .execute_branch_target_valid_i(execute_branch_target_valid),
    .kill_fetch_o                 (kill_fetch),
    .kill_decode_o                (kill_decode)
  );

  wire [31:0] fetch_pc = pc_q;
  wire [31:0] fetch_instruction;
  wire [31:0] fetch_pc_next_sequential = pc_next_sequential;
  fetch_stage fetch (
    .pc_i                 (fetch_pc),
    .instruction_o        (fetch_instruction),
    .icache_read_data_i   (icache_read_data_i),
    .icache_read_address_o(icache_read_address_o)
  );

  logic [31:0] fd_pc;
  wire  [31:0] fd_instruction_d = kill_fetch ? INSTRUCTION_NOP : fetch_instruction;
  logic [31:0] fd_instruction_q;
  logic [31:0] fd_pc_next_sequential;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      fd_pc                 <= '0;
      fd_instruction_q      <= INSTRUCTION_NOP;
      fd_pc_next_sequential <= '0;
    end else begin
      fd_pc                 <= fetch_pc;
      fd_instruction_q      <= fd_instruction_d;
      fd_pc_next_sequential <= fetch_pc_next_sequential;
    end
  end

  wire               [31:0] decode_pc = fd_pc;
  wire               [31:0] decode_instruction = fd_instruction_q;
  writeback_source_e        decode_writeback_source_selector;
  wire                      decode_write_enable;
  register_t                decode_rd_address;
  register_t                decode_rs1_address;
  register_t                decode_rs2_address;
  wire               [31:0] decode_jump_target;
  alu_operand_a_e           decode_alu_operand_a_selector;
  alu_operand_b_e           decode_alu_operand_b_selector;
  wire               [31:0] decode_immediate;
  wire               [31:0] decode_pc_next_sequential = fd_pc_next_sequential;
  wire                      decode_jump;
  decode_stage decode (
    .pc_i                       (decode_pc),
    .instruction_i              (decode_instruction),
    .writeback_source_selector_o(decode_writeback_source_selector),
    .write_enable_o             (decode_write_enable),
    .rd_address_o               (decode_rd_address),
    .rs1_address_o              (decode_rs1_address),
    .rs2_address_o              (decode_rs2_address),
    .jump_target_valid_o        (decode_jump_target_valid),
    .jump_target_o              (decode_jump_target),
    .alu_operand_a_selector_o   (decode_alu_operand_a_selector),
    .alu_operand_b_selector_o   (decode_alu_operand_b_selector),
    .immediate_o                (decode_immediate),
    .jump_o                     (decode_jump)
  );

  wire [4:0] decode_read_address[RegFileReadPortCount];
  assign decode_read_address[0] = decode_rs1_address;
  assign decode_read_address[1] = decode_rs2_address;

  wire [31:0] decode_read_data[RegFileReadPortCount];
  wire [31:0] decode_rs1_data = decode_read_data[0];
  wire [31:0] decode_rs2_data = decode_read_data[1];

  register_file_write_t register_file_write[RegFileWritePortCount];
  register_file #(
    .ReadPortCount (RegFileReadPortCount),
    .WritePortCount(RegFileWritePortCount)
  ) regfile (
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .read_address_i(decode_read_address),
    .read_data_o   (decode_read_data),
    .write_i       (register_file_write)
  );

  logic              [31:0] dx_pc;
  writeback_source_e        dx_writeback_source_selector;
  wire                      dx_write_enable_d = kill_decode ? 1'b0 : decode_write_enable;
  logic                     dx_write_enable_q;
  register_t                dx_rd_address;
  logic              [31:0] dx_rs1_data;
  logic              [31:0] dx_rs2_data;
  logic              [31:0] dx_immediate;
  logic              [31:0] dx_pc_next_sequential;
  alu_operand_a_e           dx_alu_operand_a_selector;
  alu_operand_b_e           dx_alu_operand_b_selector;
  wire                      dx_jump_d = kill_decode ? 1'b0 : decode_jump;
  logic                     dx_jump_q;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      dx_pc                        <= '0;
      dx_writeback_source_selector <= WB_SRC_ALU;
      dx_write_enable_q            <= 1'b0;
      dx_rd_address                <= REG_ZERO;
      dx_rs1_data                  <= '0;
      dx_rs2_data                  <= '0;
      dx_immediate                 <= '0;
      dx_pc_next_sequential        <= '0;
      dx_alu_operand_a_selector    <= ALU_OPERAND_A_RS1;
      dx_alu_operand_b_selector    <= ALU_OPERAND_B_IMM;
      dx_jump_q                    <= 1'b0;
    end else begin
      dx_pc                        <= fd_pc;
      dx_writeback_source_selector <= decode_writeback_source_selector;
      dx_write_enable_q            <= dx_write_enable_d;
      dx_rd_address                <= decode_rd_address;
      dx_rs1_data                  <= decode_rs1_data;
      dx_rs2_data                  <= decode_rs2_data;
      dx_immediate                 <= decode_immediate;
      dx_pc_next_sequential        <= decode_pc_next_sequential;
      dx_alu_operand_a_selector    <= decode_alu_operand_a_selector;
      dx_alu_operand_b_selector    <= decode_alu_operand_b_selector;
      dx_jump_q                    <= dx_jump_d;
    end
  end

  wire [31:0] execute_alu_result;
  wire [31:0] execute_branch_target = execute_alu_result;
  execute_stage execute (
    .alu_operand_a_selector_i(dx_alu_operand_a_selector),
    .rs1_data_i              (dx_rs1_data),
    .pc_i                    (dx_pc),
    .alu_operand_b_selector_i(dx_alu_operand_b_selector),
    .rs2_data_i              (dx_rs2_data),
    .immediate_i             (dx_immediate),
    .alu_result_o            (execute_alu_result),
    .jump_i                  (dx_jump_q),
    .branch_target_valid_o   (execute_branch_target_valid)
  );

  writeback_source_e        xm_writeback_source_selector;
  logic                     xm_write_enable;
  register_t                xm_rd_address;
  logic              [31:0] xm_alu_result;
  logic              [31:0] xm_pc_next_sequential;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      xm_writeback_source_selector <= WB_SRC_ALU;
      xm_write_enable              <= 1'b0;
      xm_rd_address                <= REG_ZERO;
      xm_alu_result                <= '0;
      xm_pc_next_sequential        <= '0;
    end else begin
      xm_writeback_source_selector <= dx_writeback_source_selector;
      xm_write_enable              <= dx_write_enable_q;
      xm_rd_address                <= dx_rd_address;
      xm_alu_result                <= execute_alu_result;
      xm_pc_next_sequential        <= dx_pc_next_sequential;
    end
  end

  writeback_source_e        mw_writeback_source_selector;
  logic                     mw_write_enable;
  register_t                mw_rd_address;
  logic              [31:0] mw_alu_result;
  logic              [31:0] mw_pc_next_sequential;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      mw_writeback_source_selector <= WB_SRC_ALU;
      mw_write_enable              <= 1'b0;
      mw_rd_address                <= REG_ZERO;
      mw_alu_result                <= '0;
      mw_pc_next_sequential        <= '0;
    end else begin
      mw_writeback_source_selector <= xm_writeback_source_selector;
      mw_write_enable              <= xm_write_enable;
      mw_rd_address                <= xm_rd_address;
      mw_alu_result                <= xm_alu_result;
      mw_pc_next_sequential        <= xm_pc_next_sequential;
    end
  end

  register_file_write_t writeback_write;
  writeback_stage writeback (
    .writeback_source_selector_i(mw_writeback_source_selector),
    .alu_result_i               (mw_alu_result),
    .pc_next_sequential_i       (mw_pc_next_sequential),
    .write_enable_i             (mw_write_enable),
    .rd_address_i               (mw_rd_address),
    .write_o                    (writeback_write)
  );

  assign register_file_write[0] = writeback_write;

  always_comb begin
    if (decode_jump_target_valid) begin
      pc_d = decode_jump_target;
    end else if (execute_branch_target_valid) begin
      pc_d = execute_branch_target;
    end else begin
      pc_d = pc_next_sequential;
    end
  end

`ifndef SYNTHESIS
  // Signals used for debugging.
  logic [31:0] dx_instruction;
  logic [31:0] xm_instruction;
  logic [31:0] mw_instruction;
  /* verilator lint_off UNUSEDSIGNAL */
  logic [31:0] mw_instruction_q;
  /* verilator lint_on UNUSEDSIGNAL */
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      dx_instruction   <= '0;
      xm_instruction   <= '0;
      mw_instruction   <= '0;
      mw_instruction_q <= '0;
    end else begin
      dx_instruction   <= fd_instruction_q;
      xm_instruction   <= dx_instruction;
      mw_instruction   <= xm_instruction;
      mw_instruction_q <= mw_instruction;
    end
  end
`endif
endmodule
