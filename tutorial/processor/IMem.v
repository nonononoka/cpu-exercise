//
// 命令メモリ
//

`include "Types.v" 


module IMem(
	input 	logic clk,	// クロック
	input 	logic rst,	// リセット
	
	output	`InsnPath 	  insn,
	input 	`InsnAddrPath addr
);

`ifdef MODEL_TECH
	
	//
	// ModelSim 用コード
	//

	`InsnPath mem[ 0 : `INSN_MEM_SIZE-1 ];
	`InsnAddrPath addrLatch;

	always_ff @( posedge clk or negedge rst ) begin
		if( !rst ) begin
			addrLatch <= `INSN_ADDR_WIDTH'h0;
		end
		else begin
			addrLatch <= addr;
		end
	end

	always_comb begin
		insn = mem[ addrLatch[ `INSN_MEM_OFFSET +: `INSN_MEM_WIDTH ] ];
		$display($stime, "insn:%h", insn);
	end

	// 命令データの読み込み
	initial	begin
		$readmemh( "../IMem.dat", mem );
	end

`else 
	
	//
	// Altera QuartusII
	//


	lpm_rom
		body(
			.address( addr[ `INSN_MEM_OFFSET +: `INSN_MEM_WIDTH ] ),
			.inclock( clk  ),
			.q      ( insn ),
			.memenab( 1'b1 )
		);
		
	defparam
		body.intended_device_family = "APEX20KE",
		body.lpm_width   = `INSN_WIDTH,
		body.lpm_widthad = `INSN_MEM_WIDTH,
		body.lpm_indata  = "REGISTERED",
		body.lpm_address_control = "REGISTERED",
		body.lpm_outdata = "UNREGISTERED",
		body.lpm_file    = "IMem.mif",
		body.lpm_type    = "LPM_ROM";


`endif	

endmodule

