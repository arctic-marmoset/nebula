package opcodes;

  localparam logic [6:0] AuiPc  = 7'b0010111;
  localparam logic [6:0] ArithI = 7'b0010011;
  localparam logic [6:0] ArithR = 7'b0110011;
  localparam logic [6:0] Branch = 7'b1100011;
  localparam logic [6:0] Jal    = 7'b1101111;
  localparam logic [6:0] Jalr   = 7'b1100111;
  localparam logic [6:0] Load   = 7'b0000011;
  localparam logic [6:0] Lui    = 7'b0110111;
  localparam logic [6:0] Store  = 7'b0100011;
  localparam logic [6:0] System = 7'b1110011;

endpackage
