`include "alu_operand.svh"
`include "immediate.svh"
`include "opcode.svh"

module decode_stage (
  input logic [31:0] pc_i,
  input logic [31:0] instruction_i,

  output logic       write_enable_o,
  output logic [4:0] rd_address_o,
  output logic [4:0] rs1_address_o,
  output logic [4:0] rs2_address_o,

  output alu_operand_a_e alu_operand_a_selector_o,
  output alu_operand_b_e alu_operand_b_selector_o,

  output logic [31:0] immediate_o
);
  wire [6:0] opcode = instruction_i[6:0];
  wire [4:0] rd_address = instruction_i[11:7];
  wire [4:0] rs1_address = instruction_i[19:15];
  wire [4:0] rs2_address = instruction_i[24:20];
  wire [2:0] funct3 = instruction_i[14:12];
  wire [6:0] funct7 = instruction_i[31:25];

  immediate_e immediate_selector;
  control_unit control (
    .opcode_i(opcode_e'(opcode)),

    .immediate_selector_o(immediate_selector),

    .alu_operand_a_selector_o,
    .alu_operand_b_selector_o,

    .write_enable_o
  );

  immediate_generator immgen (
    .instruction_i(instruction_i),
    .selector_i   (immediate_selector),
    .immediate_o
  );

  assign rd_address_o  = rd_address;
  assign rs1_address_o = rs1_address;
  assign rs2_address_o = rs2_address;
endmodule
