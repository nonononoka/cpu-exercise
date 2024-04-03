//
// ID/EX
//

`include "Types.v"

module IDEX(
    input logic clk,
    input logic rst,

    // from IFID
    input `InsnPath inIncrementedInsn,

    output `InsnPath outIncrementedInsn,

    // control signal
    input logic inRegDst,
    input logic inAluSrc,
    input logic inMemToReg,
    input logic inRegWrite,
    input logic inMemRead,
    input logic inMemWrite,
    input logic inBranch,
    input `ALUCodePath inAluCode,

    output logic outRegDst,
    output logic outAluSrc,
    output logic outMemToReg,
    output logic outRegWrite,
    output logic outMemRead,
    output logic outMemWrite,
    output logic outBranch,
    output `ALUCodePath outAluCode,

    // register file
    `DataPath inRdDataS,
    `DataPath inRdDataT,

    `DataPath outRdDataS,
    `DataPath outRdDataT,

    // RT,RD
    `RegNumPath inDcRT,
    `RegNumPath inDcRD,

    `RegNumPath outDcRT,
    `RegNumPath outDcRD,

    // for PC
    `InsnAddrPath inDisp,
    `InsnAddrPath outDisp,

    // constant for ALU
    `ConstantPath inConstant,
    `ConstantPath outConstant
);

always_ff @( posedge clk or negedge rst ) begin
    if ( !rst ) begin
      outRegDst <= `FALSE;
      outAluSrc <= `FALSE;
      outMemToReg <= `FALSE;
      outRegWrite <= `FALSE;
      outMemRead <= `FALSE;
      outMemWrite <= `FALSE;
      outBranch <= `FALSE;
      outAluCode <= `FALSE;
      outRdDataS <= `FALSE;
      outRdDataT <= `FALSE;
      outDcRT <= `FALSE;
      outDcRD <= `FALSE;
      outConstant <= `FALSE;
    end

    else begin
      outRegDst <= inRegDst;
      outAluSrc <= inAluSrc;
      outMemToReg <= inMemToReg;
      outRegWrite <= inRegWrite;
      outMemRead <= inMemRead;
      outMemWrite <= inMemWrite;
      outBranch <= inBranch;
      outAluCode <= inAluCode;
      outRdDataS <= inRdDataS;
      outRdDataT <= inRdDataT;
      outDcRT <= inDcRT;
      outDcRD <= inDcRD;
      outConstant <= inConstant;
    end
  end

endmodule