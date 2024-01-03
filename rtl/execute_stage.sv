`include "alu_operand.svh"
`include "forwarding.svh"

module execute_stage (
  // Operand A Data Sources
  input  alu_operand_a_e         alu_operand_a_selector_i,
  input  forward_source_e        rs1_forward_source_i,
  input  logic            [31:0] rs1_data_i,
  input  logic            [31:0] pc_i,
  // Operand B Data Sources
  input  alu_operand_b_e         alu_operand_b_selector_i,
  input  forward_source_e        rs2_forward_source_i,
  input  logic            [31:0] rs2_data_i,
  input  logic            [31:0] immediate_i,
  // Forwarded Data
  input  logic            [31:0] forward_memory_data_i,
  input  logic            [31:0] forward_writeback_data_i,
  // Result
  output logic            [31:0] alu_result_o,
  // Branch Signals
  input  logic                   jump_i,
  output logic                   branch_target_valid_o
);
  assign branch_target_valid_o = jump_i;

  logic [31:0] rs1_data;
  always_comb begin
    case (rs1_forward_source_i)
      default:    rs1_data = rs1_data_i;
      FW_SRC_MEM: rs1_data = forward_memory_data_i;
      FW_SRC_WB:  rs1_data = forward_writeback_data_i;
    endcase
  end

  logic [31:0] rs2_data;
  always_comb begin
    case (rs2_forward_source_i)
      default:    rs2_data = rs2_data_i;
      FW_SRC_MEM: rs2_data = forward_memory_data_i;
      FW_SRC_WB:  rs2_data = forward_writeback_data_i;
    endcase
  end

  logic [31:0] operand_a;
  always_comb begin
    case (alu_operand_a_selector_i)
      default:            operand_a = rs1_data;
      ALU_OPERAND_A_PC:   operand_a = pc_i;
      ALU_OPERAND_A_ZERO: operand_a = '0;
    endcase
  end

  logic [31:0] operand_b;
  always_comb begin
    case (alu_operand_b_selector_i)
      default:           operand_b = immediate_i;
      ALU_OPERAND_B_RS2: operand_b = rs2_data;
    endcase
  end

  assign alu_result_o = operand_a + operand_b;
endmodule
