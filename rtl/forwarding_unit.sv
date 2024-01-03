`include "forwarding.svh"
`include "register_file.svh"

module forwarding_unit (
  input  register_e       dx_rs1_address_i,
  input  register_e       dx_rs2_address_i,
  input  wire             xm_rd_address_valid_i,
  input  register_e       xm_rd_address_i,
  input  wire             mw_rd_address_valid_i,
  input  register_e       mw_rd_address_i,
  output forward_source_e execute_rs1_forward_source_o,
  output forward_source_e execute_rs2_forward_source_o
);
  always_comb begin
    execute_rs1_forward_source_o = FW_SRC_NONE;
    if (xm_rd_address_valid_i && xm_rd_address_i != '0 && xm_rd_address_i == dx_rs1_address_i) begin
      execute_rs1_forward_source_o = FW_SRC_MEM;
    end else if (mw_rd_address_valid_i && mw_rd_address_i != '0 && mw_rd_address_i == dx_rs1_address_i) begin
      execute_rs1_forward_source_o = FW_SRC_WB;
    end
  end

  always_comb begin
    execute_rs2_forward_source_o = FW_SRC_NONE;
    if (xm_rd_address_valid_i && xm_rd_address_i != '0 && xm_rd_address_i == dx_rs2_address_i) begin
      execute_rs2_forward_source_o = FW_SRC_MEM;
    end else if (mw_rd_address_valid_i && mw_rd_address_i != '0 && mw_rd_address_i == dx_rs2_address_i) begin
      execute_rs2_forward_source_o = FW_SRC_WB;
    end
  end
endmodule
