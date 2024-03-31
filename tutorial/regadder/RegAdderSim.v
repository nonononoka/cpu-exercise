//
// レジスタ・ファイルの検証用モジュール
//



// 基本的な型を定義したファイルの読み込み
`include "Types.v" 



// シミュレーションの単位時間の設定
// #~ と書いた場合，この時間が経過する．
`timescale 1ns/1ns


//
// レジスタ・ファイルの検証用のモジュール
//
module H3_RegAdderSim;

	parameter CYCLE_TIME = 10; // 1サイクルを 10ns に設定

	integer cycle;			// 測定用サイクル

	logic clk;				// クロック

	`RegNumPath rfRdNumA;	// 読み出しレジスタ番号A
	`RegNumPath rfRdNumB;	// 読み出しレジスタ番号B

	`DataPath   rfWrData;	// 書き込みデータ
	`RegNumPath rfWrNum;	// 書き込みレジスタ番号
	logic       rfWrEnable;	// 書き込み制御 1の場合，書き込みを行う

    `DataPath regAdderOut;	

	RegAdder regAdder(
		.clk( clk ),
		.rdNumA  ( rfRdNumA   ),
		.rdNumB  ( rfRdNumB   ),
		.wrData  ( rfWrData   ),
		.wrNum   ( rfWrNum    ),
		.wrEnable( rfWrEnable ),
        .dst(regAdderOut)
	);

	// クロック
	initial begin 
		clk <= 1'b1;
		cycle <= 0;
		
		// 半サイクルごとに clk を反転
	    forever #(CYCLE_TIME / 2) begin
	    	clk <= !clk ;
	    	cycle <= cycle + 1;
	    end
	end

	// 検証動作を記述する
	initial begin

		// 初期化
		rfRdNumA   = 0;
		rfRdNumB   = 0;
		rfWrData   = 0;
		rfWrNum    = 0;
		rfWrEnable = 0;

		//
		// シミュレーション開始
		//
		
		rfWrEnable = 1;	rfWrNum = 0;	rfWrData = 15;  // $0に15を代入
		#CYCLE_TIME
		
		rfWrEnable = 1;	rfWrNum = 1;	rfWrData = 14;	// $1に14を代入
		#CYCLE_TIME
		
		rfRdNumA   = 0;	rfRdNumB = 1;   		// $0と$1を読み出す
		#CYCLE_TIME

		#(CYCLE_TIME*10)
		$finish;
		// 10サイクル経過して終了
     
	end

	// シミュレーション結果の表示（クロックの立ち上がり時と立ち下がり時）
	always @( posedge clk or negedge clk ) begin 
		
		$write(
			"%s\n",
			( clk == 0 ) ?
		  		"=====================================================" :
		  		"-----------------------------------------------------");
		
		$write(
			"cycle -> %0d\n", 
		  	cycle
		);
		
		
		$write(
			"    %s WrNum[%d] WrData[%d]\n",
			(rfWrEnable) ? 
				"Write" : 
				"     ",
			rfWrNum,
			rfWrData
		);
        
		$write(
			"    %s regAdderout[%d]\n",
			(rfWrEnable) ? 
				"Write" : 
				"Add",
			regAdderOut
		);
		
		$write(
			"  %s\n",
		  	( clk == 1 ) ? "posedge clk" : "negedge clk"
		);
		
	end
  
endmodule

