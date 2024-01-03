module hazard_detection_unit (
  input  logic decode_jump_target_valid_i,
  input  logic execute_branch_target_valid_i,
  output logic kill_fetch_o,
  output logic kill_decode_o
);
  assign kill_fetch_o  = decode_jump_target_valid_i || execute_branch_target_valid_i;
  assign kill_decode_o = execute_branch_target_valid_i;
endmodule
