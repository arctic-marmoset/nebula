module decode (
    input logic         clk_i,
    input logic         rst_n_i,
    input types::word_t pc_i,
    input types::word_t instr_i
);

  import types::*;

  wire [6:0] opcode   = instr_i[ 6: 0];
  wire [4:0] addr_rd  = instr_i[11: 7];
  wire [4:0] addr_rs1 = instr_i[19:15];
  wire [4:0] addr_rs2 = instr_i[24:20];
  wire [2:0] funct3   = instr_i[14:12];
  wire [2:0] funct7   = instr_i[31:25];

  imm_t imm_type;
  always_comb begin
    case (opcode)
    default:
      imm_type = i_type;
    opcodes::Store:
      imm_type = s_type;
    opcodes::Branch:
      imm_type = b_type;
    opcodes::AuiPc,
    opcodes::Lui:
      imm_type = u_type;
    opcodes::Jal:
      imm_type = j_type;
    endcase
  end

  word_t imm;
  imm_gen imm_gen_inst (
    .instr_i(instr_i),
    .type_i (imm_type),
    .imm_o  (imm)
  );

`ifndef NDEBUG
  string s_instruction;
  bit [47:0][7:0] fs_instruction;
  always_comb begin
    s_instruction = assembly::to_string(
      pc_i,
      instr_i,
      opcode,
      addr_rd,
      addr_rs1,
      addr_rs2,
      funct3,
      funct7,
      imm
    );
    for (int i = 0; i < 48; ++i) begin
      fs_instruction[i] = s_instruction[s_instruction.len() - 1 - i];
    end
  end
`endif

endmodule