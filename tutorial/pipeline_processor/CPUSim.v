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
module H3_CPUSim;

	parameter CYCLE_TIME = 200; // 1サイクルを 10ns に設定

	integer cycle;			// 測定用サイクル

	logic clk;				// クロック

    logic rst;
	
	`InsnPath insn;	// 読み出しデータA
	`DataPath dataIn;

    `InsnAddrPath insnAddr;		// 命令メモリへのアドレス出力
	`DataAddrPath dataAddr;		// データバスへのアドレス出力
	`DataPath     dataOut;		// 書き込みデータ出力 dataAddr で指定したアドレスに対して書き込む値を出力する．
	logic         memWrite;

	CPU cpu(
		.clk( clk ),
        .rst(rst),
		.insnAddr ( insnAddr  ),
		.dataAddr ( dataAddr ),
		.dataOut  ( dataOut   ),
		.memWrite  ( memWrite  ),
		.insn  ( insn ),
		.dataIn  ( dataIn  )
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
		clk = 0;
        rst = 1;

		//
		// シミュレーション開始
		//
        insn = 34; dataIn = 0;  //r5 = r0 + 1
        #CYCLE_TIME
		
		insn = 537198593; dataIn = 0;  //r5 = r0 + 1
        #CYCLE_TIME

        insn = 537264130; dataIn = 0; //r6 = r0 + 2
        #CYCLE_TIME

        insn = 10893354; dataIn = 0; // r7 = r5 < r6
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
			"  %s\n",
		  	( clk == 1 ) ? "posedge clk" : "negedge clk"
		);
		
	end
  
endmodule