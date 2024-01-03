`ifndef FORWARDING_SVH
`define FORWARDING_SVH

typedef enum logic [1:0] {
    FW_SRC_NONE,
    FW_SRC_MEM,
    FW_SRC_WB
} forward_source_e;

`endif
