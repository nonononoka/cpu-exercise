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

	// Pipeline

	// IFID
	`InsnAddrPath incrementedInsnAddr;
	`InsnAddrPath incrementedInsnAddrToID;
	`InsnPath insnToID;

	// IDEX
	`InsnAddrPath incrementedInsnAddrToEX;

	`InsnAddrPath disp;
	`InsnAddrPath dispToEX;
	`ConstantPath constant;
	`ConstantPath constantToEX;

	`ALUCodePath aluCodeToEX;		// ALU の制御コード
	logic regDstToEX;			// 書き込みレジスタのdestination,trueならrd
	logic aLUSrcToEX; // aluの第二オペランドがレジスタの第二出力か、命令の下位16bitか
	logic memToRegToEX;			// レジスタの書き込みデータに渡される値がデータメモリかALUか
	logic regWriteToEX;	// レジスタに書きこむかどうか
	logic memReadToEX;			// ロード命令かどうか
	logic memWriteToEX;		// ストア命令かどうか
	logic branchToEX;		// ブランチ命令かどうか

	`DataPath rfRdDataSToEX;
	`DataPath rfRdDataTToEX;

	`RegNumPath dcRTToEX;			// RS フィールド
	`RegNumPath dcRDToEX;			// RT フィールド

	// EXMEM
	`InsnAddrPath tmpPcOut;
	`InsnAddrPath tmpPcOutToMem;

	logic memToRegToMEM;			// レジスタの書き込みデータに渡される値がデータメモリかALUか
	logic regWriteToMEM;	// レジスタに書きこむかどうか
	logic memReadToMEM;			// ロード命令かどうか
	logic memWriteToMEM;		// ストア命令かどうか
	logic branchToMEM;		// ブランチ命令かどうか

	logic isEqual;
	logic isEqualToMem;

	`DataPath aluOutToMem;

	`DataPath rfRdDataTToMem;
	`RegNumPath rfWrNumToMem;		// 書き込み番号

	// MEMWB
	logic memToRegToWB;			// レジスタの書き込みデータに渡される値がデータメモリかALUか
	logic regWriteToWB;
	`DataPath aluOutToWB;
	`RegNumPath rfWrNumToWB;		// 書き込み番号
	`DataPath     dataInToWB;	

	// MEMWB
	logic regWriteToID;

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
		.aluCode( dcALUCode ), // out
		.regDst( dcRegDst ), // out
		.aluSrc( dcALUSrc ), // out
		.memToReg( dcMemToReg ),	// out
		.regWrite( dcRegWrite ),	// out
		.memRead( dcMemRead ), // out
		.memWrite( dcMemWrite ),	// out
		.branch( dcBranch ),	// out
		.insn( insnToID ) // in
	);

	ALU alu (
		.aluOut( aluOut ), // out
		.aluInA( aluInA ), // in
		.aluInB( aluInB ), // in
		.code( aluCodeToEX ) // in
	);

	RegisterFile regFile(
		.clk( clk ), // in

		.rdDataA( rfRdDataS ), // out
		.rdDataB( rfRdDataT ), // out

		.rdNumA( dcRS ), // in
		.rdNumB( dcRT ), // in

		.wrData( rfWrData ), // in
		.wrNum( rfWrNumToWB ), // in
		.regWrite( regWriteToID ) // in
	);

	IFID ifid(
		.clk(clk),
		.rst(rst),
		.inInsn(insn),
		.inIncrementedInsn(incrementedInsnAddr),
		.outInsn(insnToID),
		.outIncrementedInsn(incrementedInsnAddrToID)
	);

	IDEX idex(
		.clk(clk),
		.rst(rst),

		.inIncrementedInsn(incrementedInsnAddrToID),
		.outIncrementedInsn(incrementedInsnAddrToEX),

		.inRegDst(dcRegDst),
		.inAluSrc(dcALUSrc),
		.inMemToReg(dcMemToReg),
		.inRegWrite(dcRegWrite),
		.inMemRead(dcMemRead),
		.inMemWrite(dcMemWrite),
		.inBranch(dcBranch),
		.inAluCode(dcALUCode),

		.outRegDst(regDstToEX),
		.outAluSrc(aLUSrcToEX),
		.outMemToReg(memToRegToEX),
		.outRegWrite(regWriteToEX),
		.outMemRead(memReadToEX),
		.outMemWrite(memWriteToEX),
		.outBranch(branchToEX),
		.outAluCode(aluCodeToEX),

		.inRdDataS(rfRdDataS),
		.inRdDataT(rfRdDataT),
		.outRdDataS(rfRdDataSToEX),
		.outRdDataT(rfRdDataTToEX),

		.inDcRD(dcRD),
		.inDcRT(dcRT),
		.outDcRT(dcRTToEX),
		.outDcRD(dcRDToEX),

		.inDisp(disp),
		.outDisp(dispToEX),

		.inConstant(constant),
		.outConstant(constantToEX)
	);

	EXMEM exmem(
		.clk(clk),
		.rst(rst),
		
		.inMemToReg(memToRegToEX),
		.inRegWrite(regWriteToEX),
		.inMemRead(memReadToEX),
		.inMemWrite(memWriteToEX),
		.inBranch(branchToEX),

		.outMemToReg(memToRegToMEM),
		.outRegWrite(regWriteToMEM),
		.outMemRead(memReadToMEM),
		.outMemWrite(memWriteToMEM),
		.outBranch(branchToMEM),

		.inPcOut(tmpPcOut),
		.outPcOut(tmpPcOutToMem),

		.inIsEqual(isEqual),
		.inAluOut(aluOut),

		.outIsEqual(isEqualToMem),
		.outAluOut(aluOutToMem),

		.inRfRdDataT(rfRdDataTToEX),
		.outRfRdDataT(rfRdDataTToMem),

		.inRfWrNum(rfWrNum),
		.outRfWrNum(rfWrNumToMem)
	);

	MEMWB memwb(
		.clk(clk),
		.rst(rst),
		.inMemToReg(memToRegToMEM),
		.inRegWrite(regWriteToMEM),
		.outMemToReg(memToRegToWB),
		.outRegWrite(regWriteToWB),
		.inAluOut(aluOutToMem),
		.outAluOut(aluOutToWB),
		.inRfWrNum(rfWrNumToMem),
		.outRfWrNum(rfWrNumToWB),
		.inMData(dataIn),
		.outMData(dataInToWB)
	);

	always_comb begin
		// ID
		insnAddr     = pcOut;
		incrementedInsnAddr = pcOut + `INSN_PC_INC;

		// EX
		constant = insnToID[ `CONSTAT_POS +: `CONSTAT_WIDTH ];
		disp = `EXPAND_BR_DISPLACEMENT( constantToEX );
		tmpPcOut = incrementedInsnAddrToEX - 4*`INSN_PC_INC + disp;
		$display("rfRdDataSToEX", rfRdDataSToEX);
		$display("rfRdDataTToEX", rfRdDataTToEX);
		isEqual =  (rfRdDataSToEX == rfRdDataTToEX) ? `TRUE : `FALSE;
		$display("isEqual", isEqual);
		aluInA = rfRdDataSToEX;
		aluInB = aLUSrcToEX ? constantToEX: rfRdDataTToEX;
		rfWrNum = regDstToEX ? dcRDToEX : dcRTToEX;

		// MEM
		$display("branchToMem", branchToMEM);
		$display("isEqualToMem", isEqualToMem);
		pcWrEnable = branchToMEM & isEqualToMem;
		$display("pcWrEnable", pcWrEnable);
		pcIn = tmpPcOutToMem;
		memWrite = memWriteToMEM;
		dataAddr = aluOutToMem;
		dataOut = rfRdDataTToMem;

		// WB
		regWriteToID = regWriteToWB;
		rfWrData = memToRegToWB ? dataIn : aluOutToWB;
	end

endmodule

