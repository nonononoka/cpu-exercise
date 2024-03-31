// 基本的な定数や型の定義
`include "BasicTypes.v"

// ここより下に，各人の定義を追加してください
`define OP_WIDTH 6	// 幅
`define OP_POS   26	// 開始位置
`define OpPath logic[ `OP_WIDTH-1 : 0 ]

// funct
`define FUNCT_WIDTH 6	// 幅
`define FUNCT_POS   0	// 開始位置
`define FunctPath logic[ `FUNCT_WIDTH-1 : 0 ]


`define SHAMT_WIDTH 6	// 幅
`define SHAMT_POS   6	// 開始位置
`define ShamtPath logic[ `SHAMT_WIDTH-1 : 0 ]

// 命令コード
`define OP_CODE_R  0 // R形式
`define OP_CODE_LW   35 //lw命令
`define OP_CODE_SW   43 //sw命令
`define OP_CODE_BEQ  4 //beq命令

//
// ALU のコード
//

`define ALU_CODE_WIDTH 4
`define ALUCodePath logic [ `ALU_CODE_WIDTH-1:0 ]

`define ALU_CODE_AND 0
`define ALU_CODE_OR 1
`define ALU_CODE_ADD 2
`define ALU_CODE_SUB 6
`define ALU_CODE_SLT 7
`define ALU_CODE_NOR 12

`define FUNCT_CODE_ADD 32
`define FUNCT_CODE_SUB 34
`define FUNCT_CODE_AND 36
`define FUNCT_CODE_OR  37
`define FUNCT_CODE_SLT 42

`define RS_POS 21
`define RT_POS 16
`define RD_POS 11

//
// --- レジスタ・ファイル
//

// レジスタ番号を表すために必要なビット数
// 5: 2^5 で 32 個のレジスタを表す
`define REG_NUM_WIDTH 5

// レジスタ・ファイルのサイズ
// 上に合わせて 32 個に
`define REG_FILE_SIZE 32

// レジスタ番号
`define RegNumPath logic [ `REG_NUM_WIDTH-1:0 ]