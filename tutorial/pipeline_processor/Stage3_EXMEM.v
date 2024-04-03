//
// EX/MEM
//

`include "Types.v"

module EXMEM(
    input logic clk,
    input logic rst,

    // control signal from IDEX
    input logic inMemToReg,
    input logic inRegWrite,
    input logic inMemRead,
    input logic inMemWrite,
    input logic inBranch,

    output logic outMemToReg,
    output logic outRegWrite,
    output logic outMemRead,
    output logic outMemWrite,
    output logic outBranch,

    // pcOUT
    `InsnAddrPath inPcOut,
    `InsnAddrPath outPcOut,

    // from ALU
    input logic inIsEqual,
    input `DataPath inAluOut,

    output logic outIsEqual,
    output `DataPath outAluOut,

    // from RT
    input `RegNumPath inRT,
    output `RegNumPath outRT,

    // write Register Num
    input `RegNumPath inRfWrNum,
    output `RegNumPath outRfWrNum
);

always_ff @( posedge clk or negedge rst ) begin
    if ( !rst ) begin
      outMemToReg <= `FALSE;
      outRegWrite <= `FALSE;
      outMemRead <= `FALSE;
      outMemWrite <= `FALSE;
      outBranch <= `FALSE;
      outPcOut <= `FALSE;
      outIsEqual <= `FALSE;
      outAluOut <= `FALSE;
      outRT <= `FALSE;
      outRfWrNum = `FALSE;
    end

    else begin
      outMemToReg <= inMemToReg;
      outRegWrite <= inRegWrite;
      outMemRead <= inMemRead;
      outMemWrite <= inMemWrite;
      outBranch <= inBranch;
      outPcOut <= inPcOut;
      outIsEqual <= inIsEqual;
      outAluOut <= inAluOut;
      outRT <= inRT;
      outRfWrNum = inRfWrNum;
    end
end

endmodule
