`include "Types.v"

module CPU(

	input logic clk,	// クロック
	input logic rst,	// リセット
	
	output `InsnAddrPath insnAddr,		// 命令メモリへのアドレス出力
	output `DataAddrPath dataAddr,		// データバスへのアドレス出力
	output `DataPath     dataOut,		// 書き込みデータ出力 dataAddr で指定したアドレスに対して書き込む値を出力する．
	output logic         memWrite,	// データ書き込み有効

	input  `InsnPath 	 insn,			// 命令メモリからの入力
	input  `DataPath     dataIn			// 読み出しデータ入力　dataAddr で指定したアドレスから読んだ値が入力される．
);
	// PC
	`InsnAddrPath pcOut;		// アドレス出力
	`InsnAddrPath pcIn;			// 外部書き込みをする時のアドレス
	logic pcWrEnable;

	// Decoder
	`OpPath dcOp;				// OP フィールド
	`RegNumPath dcRS;			// RS フィールド
	`RegNumPath dcRT;			// RT フィールド
	`RegNumPath dcRD;			// RD フィールド
	`ShamtPath dcShamt;			// SHAMT フィールド
	`FunctPath dcFunct;			// FUNCT フィールド
	`ALUCodePath dcALUCode;		// ALU の制御コード
	logic dcRegDst;			// 書き込みレジスタのdestination,trueならrd
	logic dcALUSrc; // aluの第二オペランドがレジスタの第二出力か、命令の下位16bitか
	logic dcMemToReg;			// レジスタの書き込みデータに渡される値がデータメモリかALUか
	logic dcRegWrite;	// レジスタに書きこむかどうか
	logic dcMemRead;			// ロード命令かどうか
	logic dcMemWrite;		// ストア命令かどうか
	logic dcBranch;		// ブランチ命令かどうか

	// レジスタ・ファイル
	`DataPath rfRdDataS;		// 読み出しデータ rs
	`DataPath rfRdDataT;		// 読み出しデータ rt
	`DataPath   rfWrData;		// 書き込みデータ
	`RegNumPath rfWrNum;		// 書き込み番号
	
	// ALU
	`DataPath aluOut;			// ALU 出力
	`DataPath aluInA;			// ALU 入力A
	`DataPath aluInB;			// ALU 入力B

	PC pc (
		.clk( clk ), // in
		.rst( rst ), // in

		.addrOut( pcOut ), // out

		.addrIn( pcIn ), // in: 外部書き込みのアドレス
		.wrEnable( pcWrEnable ) // in
	);

	Decoder decoder(
		.op( dcOp ), // out
		.rs( dcRS ), // out
		.rt( dcRT ), // out
		.rd( dcRD ), // out
		.shamt( dcShamt ), // out
		.funct( dcFunct ), // out
		.aluCode( dcALUCode ), // out
		.regDst( dcRegDst ), // out
		.aluSrc( dcALUSrc ), // out
		.memToReg( dcMemToReg ),	// out
		.regWrite( dcRegWrite ),	// out
		.memRead( dcMemRead ), // out
		.memWrite( dcMemWrite ),	// out
		.branch( dcBranch ),	// out
		.insn( insn ) // in
	);

	ALU alu (
		.aluOut( aluOut ), // out
		.aluInA( aluInA ), // in
		.aluInB( aluInB ), // in
		.code( dcALUCode ) // in
	);

	RegisterFile regFile(
		.clk( clk ), // in

		.rdDataA( rfRdDataS ), // out
		.rdDataB( rfRdDataT ), // out

		.rdNumA( dcRS ), // in
		.rdNumB( dcRT ), // in

		.wrData( rfWrData ), // in
		.wrNum( rfWrNum ), // in
		.regWrite( dcRegWrite ) // in
	);

	always_comb begin
		// regDst
		rfWrNum = dcRegDst ? dcRD : dcRT;

		// aluSrc
		aluInA = rfRdDataS;
		aluInB = dcALUSrc ? insn[ `CONSTAT_POS +: `CONSTAT_WIDTH ] : rfRdDataT ;

		// MemWrite
		memWrite = dcMemWrite;

		// MemToReg
		rfWrData = dcMemToReg ? dataIn : aluOut;

		// outputの記述
		insnAddr     = pcOut;
		dataAddr = aluOut[ `DATA_ADDR_WIDTH - 1 : 0 ];
		dataOut = rfRdDataT;	
		$display(insn, "rfWrNum", dcRegDst ,dcRT, rfWrNum, dcMemToReg, aluOut, rfWrData);
	end
endmodule

