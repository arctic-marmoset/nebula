`include "alu_operand.svh"
`include "immediate.svh"
`include "opcode.svh"
`include "register_file.svh"
`include "writeback.svh"

module decode_stage (
  input  logic              [31:0] pc_i,
  input  logic              [31:0] instruction_i,
  // Operand Read Signals
  output register_e                rs1_address_o,
  output register_e                rs2_address_o,
  // Control Flow Signals
  output logic                     jump_target_valid_o,
  output logic              [31:0] jump_target_o,
  // Execute Signals
  output alu_operand_a_e           alu_operand_a_selector_o,
  output alu_operand_b_e           alu_operand_b_selector_o,
  output logic              [31:0] immediate_o,
  output logic                     jump_o,
  // Writeback Signals
  output writeback_source_e        writeback_source_selector_o,
  output logic                     write_enable_o,
  output register_e                rd_address_o
);
  opcode_e opcode = opcode_e'(instruction_i[6:0]);
  register_e rd_address = register_e'(instruction_i[11:7]);
  register_e rs1_address = register_e'(instruction_i[19:15]);
  register_e rs2_address = register_e'(instruction_i[24:20]);
  wire [2:0] funct3 = instruction_i[14:12];
  wire [6:0] funct7 = instruction_i[31:25];

  immediate_e immediate_selector;
  logic jump_target_valid;
  control_unit control (
    .opcode_i            (opcode),
    .immediate_selector_o(immediate_selector),
    .early_jump_o        (jump_target_valid),
    .alu_operand_a_selector_o,
    .alu_operand_b_selector_o,
    .jump_o,
    .writeback_source_selector_o,
    .write_enable_o
  );

  logic [31:0] immediate;
  immediate_generator immgen (
    .instruction_i(instruction_i),
    .selector_i   (immediate_selector),
    .immediate_o  (immediate)
  );

  wire [31:0] jump_target = pc_i + immediate;

  assign rd_address_o        = rd_address;
  assign rs1_address_o       = rs1_address;
  assign rs2_address_o       = rs2_address;
  assign jump_target_valid_o = jump_target_valid;
  assign jump_target_o       = jump_target;
  assign immediate_o         = immediate;
endmodule
