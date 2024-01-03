`ifndef ALU_OPERAND_SVH
`define ALU_OPERAND_SVH

typedef enum logic [1:0] {
    ALU_OPERAND_A_RS1,
    ALU_OPERAND_A_PC,
    ALU_OPERAND_A_ZERO
} alu_operand_a_e;

typedef enum logic {
    ALU_OPERAND_B_IMM,
    ALU_OPERAND_B_RS2
} alu_operand_b_e;

`endif
