`include "Types.v"

module Decoder (
    output `OpPath op,
    output `RegNumPath rs,
    output `RegNumPath rt,
    output `RegNumPath rd,
    output `ShamtPath shamt,
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
    `FunctPath funct;

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
                regDst = `TRUE;
                aluSrc = `FALSE;
                memToReg = `FALSE;
                regWrite =  `TRUE;
                memRead = `FALSE;
                memWrite = `FALSE;
                branch = `FALSE;
            end
            `OP_CODE_LW: begin
                regDst = `FALSE;
                aluSrc =  `TRUE;
                memToReg =  `TRUE;
                regWrite =  `TRUE;
                memRead =  `TRUE;
                memWrite = `FALSE;
                branch = `FALSE;
            end
            `OP_CODE_SW: begin 
                regDst = `FALSE;
                aluSrc =  `TRUE;
                memToReg = `FALSE;
                regWrite = `FALSE;
                memRead = `FALSE;
                memWrite =  `TRUE;
                branch = `FALSE;
            end
            `OP_CODE_BEQ: begin
                regDst = `FALSE;
                aluSrc = `FALSE;
                memToReg =  `TRUE;
                regWrite = `FALSE;
                memRead = `FALSE;
                memWrite = `FALSE;
                branch =  `TRUE;
            end
            `OP_CODE_ADDI: begin
                regDst = `FALSE;
                aluSrc = `TRUE;
                memToReg =  `FALSE;
                regWrite = `TRUE;
                memRead = `FALSE;
                memWrite = `FALSE;
                branch =  `FALSE;
            end
            `OP_CODE_ANDI: begin
                regDst = `FALSE;
                aluSrc = `TRUE;
                memToReg =  `FALSE;
                regWrite = `TRUE;
                memRead = `FALSE;
                memWrite = `FALSE;
                branch =  `FALSE;
            end
            default: begin
                regDst = `FALSE;
                aluSrc = `TRUE;
                memToReg =  `FALSE;
                regWrite = `TRUE;
                memRead = `FALSE;
                memWrite = `FALSE;
                branch =  `FALSE;
            end
        endcase

        // create ALUCOde
        if(op == `OP_CODE_LW || op == `OP_CODE_SW || op == `OP_CODE_ADDI)
            aluCode = `ALU_CODE_ADD;
        else if (op == `OP_CODE_ANDI)
            aluCode = `ALU_CODE_AND;
        else if(op == `OP_CODE_BEQ)
            aluCode = `ALU_CODE_SUB;
        else begin
            case(funct)
            `FUNCT_CODE_ADD: aluCode = `ALU_CODE_ADD;
            `FUNCT_CODE_SUB: aluCode = `ALU_CODE_SUB;
            `FUNCT_CODE_AND: aluCode = `ALU_CODE_AND;
            `FUNCT_CODE_OR: aluCode = `ALU_CODE_OR;
            `FUNCT_CODE_SLT: aluCode = `ALU_CODE_SLT;
            default: aluCode = `ALU_CODE_ADD;
            endcase
        end
    end

endmodule