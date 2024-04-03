//
// before PC
//

`include "Types.v"

module prevPC(
    input logic clk,
    input logic rst,
    input logic inWrEnable,
    output logic outWrEnable
);
 always_ff @( posedge clk or negedge rst ) begin
    if ( !rst ) begin
      outWrEnable <= `FALSE;
    end
    else begin
      outWrEnable <= inWrEnable;
    end
  end

endmodule