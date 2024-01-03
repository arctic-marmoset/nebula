`include "alu_operand.svh"
`include "common.svh"
`include "register_file.svh"

module core #(
  parameter unsigned ResetAddress = `RESET_ADDRESS
) (
  input logic clk_i,
  input logic rst_i,

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

  wire [31:0] fetch_pc = pc_q;
  wire [31:0] fetch_instruction;
  fetch_stage fetch (
    .pc_i         (fetch_pc),
    .instruction_o(fetch_instruction),

    .icache_read_data_i   (icache_read_data_i),
    .icache_read_address_o(icache_read_address_o)
  );

  logic [31:0] fd_pc;
  logic [31:0] fd_instruction;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      fd_pc          <= '0;
      fd_instruction <= INSTRUCTION_NOP;
    end else begin
      fd_pc          <= fetch_pc;
      fd_instruction <= fetch_instruction;
    end
  end

  wire            [31:0] decode_pc = fd_pc;
  wire            [31:0] decode_instruction = fd_instruction;
  wire                   decode_write_enable;
  wire            [ 4:0] decode_rd_address;
  wire            [ 4:0] decode_rs1_address;
  wire            [ 4:0] decode_rs2_address;
  wire            [31:0] decode_immediate;
  alu_operand_a_e        decode_alu_operand_a_selector;
  alu_operand_b_e        decode_alu_operand_b_selector;
  decode_stage decode (
    .pc_i         (decode_pc),
    .instruction_i(decode_instruction),

    .write_enable_o(decode_write_enable),
    .rd_address_o  (decode_rd_address),
    .rs1_address_o (decode_rs1_address),
    .rs2_address_o (decode_rs2_address),

    .alu_operand_a_selector_o(decode_alu_operand_a_selector),
    .alu_operand_b_selector_o(decode_alu_operand_b_selector),

    .immediate_o(decode_immediate)
  );

  wire [4:0] decode_read_address[RegFileReadPortCount];
  assign decode_read_address[0] = decode_rs1_address;
  assign decode_read_address[1] = decode_rs2_address;

  wire [31:0] decode_read_data[RegFileReadPortCount];
  wire [31:0] decode_rs1_data = decode_read_data[0];
  wire [31:0] decode_rs2_data = decode_read_data[1];

  register_file_write_t writeback_write[RegFileWritePortCount];
  register_file #(
    .ReadPortCount (RegFileReadPortCount),
    .WritePortCount(RegFileWritePortCount)
  ) regfile (
    .clk_i(clk_i),
    .rst_i(rst_i),

    .read_address_i(decode_read_address),
    .read_data_o   (decode_read_data),

    .write_i(writeback_write)
  );

  logic           [31:0] dx_pc;
  logic                  dx_write_enable;
  logic           [ 4:0] dx_rd_address;
  logic           [31:0] dx_rs1_data;
  logic           [31:0] dx_rs2_data;
  logic           [31:0] dx_immediate;
  alu_operand_a_e        dx_alu_operand_a_selector;
  alu_operand_b_e        dx_alu_operand_b_selector;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      dx_pc                     <= '0;
      dx_write_enable           <= 1'b0;
      dx_rd_address             <= '0;
      dx_rs1_data               <= '0;
      dx_rs2_data               <= '0;
      dx_immediate              <= '0;
      dx_alu_operand_a_selector <= ALU_OPERAND_A_RS1;
      dx_alu_operand_b_selector <= ALU_OPERAND_B_IMM;
    end else begin
      dx_pc                     <= fd_pc;
      dx_write_enable           <= decode_write_enable;
      dx_rd_address             <= decode_rd_address;
      dx_rs1_data               <= decode_rs1_data;
      dx_rs2_data               <= decode_rs2_data;
      dx_immediate              <= decode_immediate;
      dx_alu_operand_a_selector <= decode_alu_operand_a_selector;
      dx_alu_operand_b_selector <= decode_alu_operand_b_selector;
    end
  end

  wire [31:0] execute_alu_result;
  execute_stage execute (
    .alu_operand_a_selector_i(dx_alu_operand_a_selector),
    .rs1_data_i              (dx_rs1_data),
    .pc_i                    (dx_pc),

    .alu_operand_b_selector_i(dx_alu_operand_b_selector),
    .rs2_data_i              (dx_rs2_data),
    .immediate_i             (dx_immediate),

    .alu_result_o(execute_alu_result)
  );

  logic        xm_write_enable;
  logic [ 4:0] xm_rd_address;
  logic [31:0] xm_alu_result;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      xm_write_enable <= 1'b0;
      xm_rd_address   <= '0;
      xm_alu_result   <= '0;
    end else begin
      xm_write_enable <= dx_write_enable;
      xm_rd_address   <= dx_rd_address;
      xm_alu_result   <= execute_alu_result;
    end
  end

  logic        mw_write_enable;
  logic [ 4:0] mw_rd_address;
  logic [31:0] mw_alu_result;
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      mw_write_enable <= 1'b0;
      mw_rd_address   <= '0;
      mw_alu_result   <= '0;
    end else begin
      mw_write_enable <= xm_write_enable;
      mw_rd_address   <= xm_rd_address;
      mw_alu_result   <= xm_alu_result;
    end
  end

  assign writeback_write[0] = '{mw_write_enable, mw_rd_address, mw_alu_result};

  assign pc_d = pc_next_sequential;
endmodule
