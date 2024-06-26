`include "Types.v"

module ALU(
  output `DataPath aluOut,

  input `DataPath aluInA,
  input `DataPath aluInB,
  input `ALUCodePath code
);
    always_comb begin
        // $display ($stime,"alubegin",aluInA,aluInB ,code);
        case(code)
        `ALU_CODE_ADD:
            aluOut = aluInA + aluInB;
        `ALU_CODE_SUB:
            aluOut = aluInA - aluInB;
        `ALU_CODE_OR:
			aluOut = aluInA | aluInB;
		`ALU_CODE_AND:
			aluOut = aluInA & aluInB;
		`ALU_CODE_SLT: 
			aluOut = aluInA < aluInB ? `TRUE : `FALSE;
        `ALU_CODE_NOR: 
			aluOut = !(aluInA | aluInB); 
        default:
            aluOut = aluInA + aluInB;
        endcase
        // $display ($stime,"alu",code, aluOut);
    end

endmodule