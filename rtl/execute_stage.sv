`include "alu_operand.svh"

module execute_stage (
  input alu_operand_a_e        alu_operand_a_selector_i,
  input logic           [31:0] rs1_data_i,
  input logic           [31:0] pc_i,

  input alu_operand_b_e        alu_operand_b_selector_i,
  input logic           [31:0] rs2_data_i,
  input logic           [31:0] immediate_i,

  output logic [31:0] alu_result_o
);

  logic [31:0] operand_a;
  always_comb begin
    case (alu_operand_a_selector_i)
      default:            operand_a = rs1_data_i;
      ALU_OPERAND_A_PC:   operand_a = pc_i;
      ALU_OPERAND_A_ZERO: operand_a = '0;
    endcase
  end

  logic [31:0] operand_b;
  always_comb begin
    case (alu_operand_b_selector_i)
      default:           operand_b = immediate_i;
      ALU_OPERAND_B_RS2: operand_b = rs2_data_i;
    endcase
  end

  assign alu_result_o = operand_a + operand_b;
endmodule