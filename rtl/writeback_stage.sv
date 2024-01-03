`include "register_file.svh"
`include "writeback.svh"

module writeback_stage (
  input  writeback_source_e           writeback_source_selector_i,
  input  logic                 [31:0] alu_result_i,
  input  logic                 [31:0] pc_next_sequential_i,
  input  logic                        write_enable_i,
  input  register_t                   rd_address_i,
  output register_file_write_t        write_o
);
  logic [31:0] write_data;
  always_comb begin
    case (writeback_source_selector_i)
      default:                   write_data = alu_result_i;
      WB_SRC_PC_NEXT_SEQUENTIAL: write_data = pc_next_sequential_i;
    endcase
  end

  assign write_o = '{write_enable_i, rd_address_i, write_data};
endmodule
