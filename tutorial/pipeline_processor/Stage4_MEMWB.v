`include "Types.v"

module MEMWB(
    input logic clk,
    input logic rst,

    // control signal from EXMEM
    input logic inMemToReg,
    input logic inRegWrite,

    output logic outMemToReg,
    output logic outRegWrite,

    // from ALU
    input `DataPath inAluOut,
    output `DataPath outAluOut,

    // write Register Num
    input `RegNumPath inRfWrNum,
    output `RegNumPath outRfWrNum,

    // data
    input `DataPath inMData,
    output `DataPath outMData
);

always_ff @( posedge clk or negedge rst ) begin
    if ( !rst ) begin
      outMemToReg <= `FALSE;
      outRegWrite <= `FALSE;
      outAluOut <= `FALSE;
      outRfWrNum <= `FALSE;
      outMData <= `FALSE;
    end

    else begin
      outMemToReg <= inMemToReg;
      outRegWrite <= inRegWrite;
      outAluOut <= inAluOut;
      outRfWrNum <= inRfWrNum;
      outMData <= inMData;
    end
end


endmodule
