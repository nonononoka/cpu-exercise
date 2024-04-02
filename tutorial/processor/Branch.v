`include "Types.v"

module BranchUnit(
	output `InsnAddrPath pcOut,
	input `InsnAddrPath pcIn,
	input `DataPath     regRS,
	input `DataPath     regRT,
	input `ConstantPath constant
);

	logic brTaken;
	`InsnAddrPath disp;

	always_comb begin
		brTaken =  (regRS == regRT) ? `TRUE : `FALSE;

		disp = `EXPAND_BR_DISPLACEMENT( constant );
 		pcOut =
 			pcIn + `INSN_PC_INC + (brTaken ? disp : `INSN_ADDR_WIDTH'h0); // 相対addr
	end

endmodule