//
// IF/ID
//

`include "Types.v"

module IFID(
    input logic clk,
    input logic rst,
    input `InsnPath insnFromIMem,
    input `InsnPath incrementedInsnFromIMem,
    output `InsnPath insnToID_EX,
    output `InsnPath incrementedInsnToID_EX
);
 always_ff @( posedge clk or negedge rst ) begin
    if ( !rst ) begin
      insnToID_EX <= `FALSE;
      incrementedInsnToID_EX <= `FALSE;
    end
    else begin
      insnToID_EX <= insnFromIMem;
      incrementedInsnToIDEX <= incrementedInsnFromIMem;
    end
  end

endmodule