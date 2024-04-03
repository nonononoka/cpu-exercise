//
// ID/EX
//

`include "Types.v"

module IDEX(
    input logic clk,
    input logic rst,

    // from IFID
    input `InsnAddrPath inIncrementedInsn,

    output `InsnAddrPath outIncrementedInsn,

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
    input `DataPath inRdDataS,
    input `DataPath inRdDataT,

    output `DataPath outRdDataS,
    output `DataPath outRdDataT,

    // RT,RD
    input `RegNumPath inDcRT,
    input `RegNumPath inDcRD,

    output `RegNumPath outDcRT,
    output `RegNumPath outDcRD,

    // for PC
    input `InsnAddrPath inDisp,
    output `InsnAddrPath outDisp,

    // constant for ALU
    input `ConstantPath inConstant,
    output `ConstantPath outConstant
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
    $display("IDEX%h",outAluSrc);
  end

endmodule