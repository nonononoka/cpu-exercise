//
// IF/ID
//

`include "Types.v"

module IFID(
    input logic clk,
    input logic rst,
    input `InsnPath inInsn,
    input `InsnPath inIncrementedInsn,
    output `InsnPath outInsn,
    output `InsnPath outIncrementedInsn
);
 always_ff @( posedge clk or negedge rst ) begin
    if ( !rst ) begin
      outInsn <= `FALSE;
      outIncrementedInsn <= `FALSE;
    end
    else begin
      outInsn <= inInsn;
      outIncrementedInsn <= inIncrementedInsn;
    end
  end

endmodule