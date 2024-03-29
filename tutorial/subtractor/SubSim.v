//
// 減算器の検証用モジュール
//



// 基本的な型を定義したファイルの読み込み
`include "Types.v" 



// シミュレーションの単位時間の設定
// #~ と書いた場合，この時間が経過する．
`timescale 1ns/1ns


//
// 減算器の検証用のモジュール
//
module H3_Simulator;

    `DataPath subtractorInA, subtractorInB;
    `DataPath subtractorOut;

    Subtractor subtractor(
		.dst ( subtractorOut ), 	// Adder の dst  に adderOut を接続
		.srcA( subtractorInA ), 	// Adder の srcA に adderInA を接続
		.srcB( subtractorInB ) 	// Adder の srcB に adderInB を接続 
	);

    initial begin       

		//シミュレーション開始
		
		subtractorInA = 8;	// A に 1 代入
		subtractorInB = 1;	// B に 8 代入

		#40 			// 40ns 経過させる（40 * 1timescale）

		subtractorInA = 9;	// A に 9 代入
		subtractorInB = 6;   // B に 6 代入

		#20 			// 20ns 経過

		$finish;		// シミュレーション終了
		
	end

    initial 
		$monitor(
			$stime, 					// 現在の時間
			" a(%d) - b(%d) = c(%d)", 	// printf と同様の書式設定
			subtractorInA, 
			subtractorInB,
			subtractorOut
		);

endmodule


