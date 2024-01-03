`include "register_file.svh"

module register_file #(
  parameter unsigned RegisterCount  = 32,
  parameter unsigned ReadPortCount  = 2,
  parameter unsigned WritePortCount = 1
) (
  input  logic                        clk_i,
  input  logic                        rst_i,
  // Read Ports
  input  register_e                   read_address_i[ ReadPortCount],
  output logic                 [31:0] read_data_o   [ ReadPortCount],
  // Write Ports
  input  register_file_write_t        write_i       [WritePortCount]
);
  logic [31:0] registers[RegisterCount];
`ifndef SYNTHESIS
  initial begin
    for (int i = 0; i < RegisterCount; ++i) begin
      registers[i] = $urandom;
    end
  end
`endif

  logic write_valid[WritePortCount];
  always_comb begin
    for (int i = 0; i < WritePortCount; ++i) begin
      write_valid[i] = write_i[i].enable && write_i[i].address != 'd0;
    end
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      registers[REG_ZERO] <= '0;
    end else begin
      for (int i = 0; i < WritePortCount; ++i) begin
        if (write_valid[i]) begin
          registers[write_i[i].address] <= write_i[i].data;
        end
      end
    end
  end

  logic [31:0] read_data[ReadPortCount];
  always_comb begin
    for (int write_index = 0; write_index < WritePortCount; ++write_index) begin
      for (int read_index = 0; read_index < ReadPortCount; ++read_index) begin
        if (
          write_valid[write_index] &&
            write_i[write_index].address != '0 &&
            read_address_i[read_index] == write_i[write_index].address
        ) begin
          read_data[read_index] = write_i[write_index].data;
        end else begin
          read_data[read_index] = registers[read_address_i[read_index]];
        end
      end
    end
  end

  assign read_data_o = read_data;

`ifndef SYNTHESIS
  always_ff @(posedge clk_i) begin
    if (!rst_i) begin
      assert (registers[0] == 0)
      else $fatal(1, "register x0 should always hold the value 0");
    end
  end
`endif
endmodule
