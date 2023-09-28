package nebula;

  typedef logic [63:0] dword_t;
  typedef logic [31:0] word_t;
  typedef logic [15:0] hword_t;

  typedef word_t x_t;

  typedef enum bit [2:0] {
    i_type,
    s_type,
    b_type,
    u_type,
    j_type
  } imm_t;

endpackage
