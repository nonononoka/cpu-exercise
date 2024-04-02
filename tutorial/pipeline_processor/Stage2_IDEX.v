//
// ID/EX
//

`include "Types.v"

module IDEX(
    input logic clk,
    input logic rst,

    // from IFID
    input `InsnPath incrementedInsnFromIFID,

    // control bit
    input logic regDst,
    input logic aluSrc,
    input logic memToReg,
    input logic regWrite,
    input logic memRead,
    input logic memWrite,
    input logic branch,
    input `ALUCodePath aluCode,
);

endmodule