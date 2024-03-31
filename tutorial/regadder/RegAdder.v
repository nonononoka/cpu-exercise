//
// 2 Read / 1 Write レジスタ・ファイル
//


// 基本的な型を定義したファイルの読み込み
`include "Types.v" 
`include "/media/sf_nonoka_ubuntu_share/cpu-exercise/tutorial/adder/Adder.v" 
`include "/media/sf_nonoka_ubuntu_share/cpu-exercise/tutorial/regfile/RegFile.v" 

module RegAdder(
	input logic clk,			// クロック

	input `RegNumPath rdNumA,	// 読み出しレジスタ番号A
	input `RegNumPath rdNumB,	// 読み出しレジスタ番号B
    
    input `DataPath   wrData,	// 書き込みデータ
	input `RegNumPath wrNum,	// 書き込みレジスタ番号
	input logic       wrEnable,	// 書き込み制御 1の場合，書き込みを行う
    output `DataPath dst
);

	`DataPath rdDataA; 
	`DataPath rdDataB; 

	RegisterFile regfile(clk, rdDataA, rdDataB, rdNumA, rdNumB, wrData,wrNum,wrEnable);

    Adder adder(dst, rdDataA, rdDataB);

endmodule
