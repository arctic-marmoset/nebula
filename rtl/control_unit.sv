`include "immediate.svh"
`include "opcodes.svh"

module control_unit (
  input  opcode_e    opcode_i,
  output immediate_e immediate_type_o
);
  always_comb begin
    case (opcode_i)
      default:          immediate_type_o = IMM_I;
      OP_AUIPC, OP_LUI: immediate_type_o = IMM_U;
    endcase
  end
endmodule
