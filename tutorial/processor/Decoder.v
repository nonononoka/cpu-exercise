`include "Types.v"

module Decoder (
    output `OpPath op,
    output `RegNumPath rs,
    output `RegNumPath rt,
    output `RegNumPath rd,
    output `ShamtPath shamt,
    output `FunctPath funct,
    output `ALUCodePath aluCode,
    output logic regDst,
    output logic aluSrc,
    output logic memToReg,
    output logic regWrite,
    output logic memRead,
    output logic memWrite,
    output logic branch,
    input `InsnPath insn
);
    logic aluOp1;
    logic aluOp0;
    always_comb begin

        op    = insn[ `OP_POS +: `OP_WIDTH      ];
		rs    = insn[ `RS_POS +: `REG_NUM_WIDTH ];
		rt    = insn[ `RT_POS +: `REG_NUM_WIDTH ];
		rd    = insn[ `RD_POS +: `REG_NUM_WIDTH ];

		shamt   = insn[ `SHAMT_POS   +: `SHAMT_WIDTH   ];
		funct   = insn[ `FUNCT_POS   +: `FUNCT_WIDTH   ];

        // create operator code(p260)
        case(op)
            `OP_CODE_R: begin
                regDst = 1;
                aluSrc = 0;
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp1 = 1; 
                aluOp0 = 0;
            end
            `OP_CODE_LW: begin
                regDst = 0;
                aluSrc = 1;
                memToReg = 1;
                regWrite = 1;
                memRead = 1;
                memWrite = 0;
                branch = 0;
                aluOp1 = 0;
                aluOp0 = 0;
            end
            `OP_CODE_SW: begin 
                regDst = 0;
                aluSrc = 1;
                memToReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 1;
                branch = 0;
                aluOp1 = 0;
                aluOp0 = 0;
            end
            `OP_CODE_BEQ: begin
                regDst = 0;
                aluSrc = 0;
                memToReg = 1;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 1;
                aluOp1 = 0;
                aluOp0 = 1;
            end
        endcase

        // create ALUCOde
        if(op == `OP_CODE_LW || op == `OP_CODE_SW)
            aluCode = `ALU_CODE_ADD;
        else if(op == `OP_CODE_BEQ)
            aluCode = `ALU_CODE_SUB;
        else begin
            case(funct)
            `FUNCT_CODE_ADD: aluCode = `ALU_CODE_ADD;
            `FUNCT_CODE_SUB: aluCode = `ALU_CODE_SUB;
            `FUNCT_CODE_AND: aluCode = `ALU_CODE_AND;
            `FUNCT_CODE_OR: aluCode = `ALU_CODE_OR;
            `FUNCT_CODE_SLT: aluCode = `ALU_CODE_SLT;
            endcase
        end
    end

endmodule