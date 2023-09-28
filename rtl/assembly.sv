package assembly;

  import nebula::word_t;

  function static string to_string(
    word_t       pc,
    word_t       instr,
    logic  [6:0] opcode,
    logic  [4:0] addr_rd,
    logic  [4:0] addr_rs1,
    logic  [4:0] addr_rs2,
    logic  [2:0] funct3,
    logic  [2:0] funct7,
    word_t       imm
  );
    string mnemonic;
    string destination;
    string source1;
    string source2;
    string immediate;

    if (instr == 32'h10500073) begin
      return "wfi";
    end

    case (opcode)
      opcodes::Lui: begin
        mnemonic = "lui";
        destination = register_name(addr_rd);
        immediate = $sformatf("0x%h", imm);
        return $sformatf("%s %s, %s", mnemonic, destination, immediate);
      end

      opcodes::AuiPc: begin
        mnemonic = "auipc";
        destination = register_name(addr_rd);
        immediate = $sformatf("0x%h", imm);
        return $sformatf("%s %s, %s", mnemonic, destination, immediate);
      end

      opcodes::ArithI: begin
        mnemonic = {arithmetic(funct3, funct7), "i"};
        destination = register_name(addr_rd);
        source1 = register_name(addr_rs1);
        immediate = $sformatf("%-d (0x%h)", $signed(imm), imm);
        return $sformatf("%s %s, %s, %s", mnemonic, destination, source1, immediate);
      end

      opcodes::ArithR: begin
        mnemonic = arithmetic(funct3, funct7);
        destination = register_name(addr_rd);
        source1 = register_name(addr_rs1);
        source2 = register_name(addr_rs2);
        return $sformatf("%s %s, %s, %s", mnemonic, destination, source1, source2);
      end

      opcodes::Jal: begin
        mnemonic = "jal";
        destination = register_name(addr_rd);
        immediate = $sformatf("0x%h", pc + imm);
        return $sformatf("%s %s, %s", mnemonic, destination, immediate);
      end

      opcodes::Jalr: begin
        mnemonic = "jalr";
        destination = register_name(addr_rd);
        source1 = register_name(addr_rs1);
        immediate = $sformatf("0x%h", imm);
        return $sformatf("%s %s, %s, %s", mnemonic, destination, source1, immediate);
      end

      default: ;
    endcase

    return "unknown instruction";
  endfunction

  function static string arithmetic(logic [2:0] funct3, logic [6:0] funct7);
    case (funct3)
      3'b000:  return "add";
      default: return "?";
    endcase
  endfunction

  function static string register_name(logic [4:0] address);
    case (address)
      5'd0: return "x0";
      5'd1: return "x1";
      5'd2: return "x2";
      5'd3: return "x3";
      5'd4: return "x4";
      5'd5: return "x5";
      5'd6: return "x6";
      5'd7: return "x7";
      5'd8: return "x8";
      5'd9: return "x9";
      5'd10: return "x10";
      5'd11: return "x11";
      5'd12: return "x12";
      5'd13: return "x13";
      5'd14: return "x14";
      5'd15: return "x15";
      5'd16: return "x16";
      5'd17: return "x17";
      5'd18: return "x18";
      5'd19: return "x19";
      5'd20: return "x20";
      5'd21: return "x21";
      5'd22: return "x22";
      5'd23: return "x23";
      5'd24: return "x24";
      5'd25: return "x25";
      5'd26: return "x26";
      5'd27: return "x27";
      5'd28: return "x28";
      5'd29: return "x29";
      5'd30: return "x30";
      5'd31: return "x31";
      default: return "x?";
    endcase
  endfunction

endpackage
