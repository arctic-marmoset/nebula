`include "alu_operand.svh"
`include "immediate.svh"
`include "opcode.svh"

module control_unit (
  input opcode_e opcode_i,

  output immediate_e immediate_selector_o,

  output alu_operand_a_e alu_operand_a_selector_o,
  output alu_operand_b_e alu_operand_b_selector_o,

  output logic write_enable_o
);
  always_comb begin
    case (opcode_i)
      default:          immediate_selector_o = IMM_I;
      OP_STORE:         immediate_selector_o = IMM_S;
      OP_BRANCH:        immediate_selector_o = IMM_B;
      OP_AUIPC, OP_LUI: immediate_selector_o = IMM_U;
      OP_JAL:           immediate_selector_o = IMM_J;
    endcase
  end

  always_comb begin
    case (opcode_i)
      default:                     alu_operand_a_selector_o = ALU_OPERAND_A_RS1;
      OP_AUIPC, OP_BRANCH, OP_JAL: alu_operand_a_selector_o = ALU_OPERAND_A_PC;
      OP_LUI:                      alu_operand_a_selector_o = ALU_OPERAND_A_ZERO;
    endcase
  end

  always_comb begin
    case (opcode_i)
      default: alu_operand_b_selector_o = ALU_OPERAND_B_IMM;
      OP_REG:  alu_operand_b_selector_o = ALU_OPERAND_B_RS2;
    endcase
  end

  always_comb begin
    case (opcode_i)
      default:             write_enable_o = 1'b1;
      OP_BRANCH, OP_STORE: write_enable_o = 1'b0;
    endcase
  end
endmodule
