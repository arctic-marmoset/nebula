module imm_gen (
    input  nebula::word_t instr_i,
    input  nebula::imm_t  type_i,
    output nebula::word_t imm_o
);

  import nebula::*;

  wire [31:0] imm_i_type = {{20{instr_i[31]}}, instr_i[31:20]};
  wire [31:0] imm_s_type = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
  wire [31:0] imm_b_type = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
  wire [31:0] imm_u_type = {instr_i[31:12], 12'h000};
  wire [31:0] imm_j_type = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};

  always_comb begin
    case (type_i)
      i_type: imm_o = imm_i_type;
      s_type: imm_o = imm_s_type;
      b_type: imm_o = imm_b_type;
      u_type: imm_o = imm_u_type;
      j_type: imm_o = imm_j_type;
      default:
`ifndef NDEBUG
      assert (0) else $fatal(1, "unhandled immediate type!")
`endif
      ;
    endcase
  end

endmodule
