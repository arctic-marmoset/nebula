`include "immediate.svh"

module immediate_generator (
  input  logic       [31:0] instruction_i,
  input  immediate_e        type_i,
  output logic       [31:0] immediate_o
);
  /* verilator lint_off UNUSEDSIGNAL */
  wire [6:0] opcode = instruction_i[6:0];
  /* verilator lint_on UNUSEDSIGNAL */

  wire [31:0] i_type = {{20{instruction_i[31]}}, instruction_i[31:20]};
  wire [31:0] s_type = {{20{instruction_i[31]}}, instruction_i[31:25], instruction_i[11:7]};
  wire [31:0] b_type = {{20{instruction_i[31]}}, instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0};
  wire [31:0] u_type = {instruction_i[31:12], 12'h000};
  wire [31:0] j_type = {{12{instruction_i[31]}}, instruction_i[19:12], instruction_i[20], instruction_i[30:21], 1'b0};

  always_comb begin
    case (type_i)
      default: immediate_o = i_type;
      IMM_S:   immediate_o = s_type;
      IMM_B:   immediate_o = b_type;
      IMM_U:   immediate_o = u_type;
      IMM_J:   immediate_o = j_type;
    endcase
  end
endmodule
