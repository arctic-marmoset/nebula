`include "alu_operand.svh"
`include "immediate.svh"
`include "opcode.svh"
`include "writeback.svh"

module control_unit (
  input  opcode_e           opcode_i,
  // Decode Signals
  output immediate_e        immediate_selector_o,
  output logic              early_jump_o,
  // Execute Signals
  output alu_operand_a_e    alu_operand_a_selector_o,
  output alu_operand_b_e    alu_operand_b_selector_o,
  output logic              jump_o,
  // Writeback Signals
  output writeback_source_e writeback_source_selector_o,
  output logic              write_enable_o
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

  assign early_jump_o = opcode_i == OP_JAL;
  assign jump_o = opcode_i == OP_JALR;

  always_comb begin
    case (opcode_i)
      default:             alu_operand_a_selector_o = ALU_OPERAND_A_RS1;
      OP_AUIPC, OP_BRANCH: alu_operand_a_selector_o = ALU_OPERAND_A_PC;
      OP_LUI:              alu_operand_a_selector_o = ALU_OPERAND_A_ZERO;
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
      default:         writeback_source_selector_o = WB_SRC_ALU;
      OP_JAL, OP_JALR: writeback_source_selector_o = WB_SRC_PC_NEXT_SEQUENTIAL;
    endcase
  end

  always_comb begin
    case (opcode_i)
      default:             write_enable_o = 1'b1;
      OP_BRANCH, OP_STORE: write_enable_o = 1'b0;
    endcase
  end
endmodule
