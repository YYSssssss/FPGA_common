// =================================================================================================
// File Name      : UART_TOP.v
// Module         : UART_TOP
// Function       : COM_IO Control
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by        Contents
// 0.0.1      2011/10/10   TEDWX)wei.w	   create new 
// 1.0.1      2014/08/28   TEDWX)Guo.j     1)Modify to Verilog
//										   2)Modify Address Format from 8bit to 16 bit
// =================================================================================================
// End Revision
// =================================================================================================

// =============================================================================
// Timescale Define
// =============================================================================

`timescale 1ns / 1ps

module uart_top# (
	parameter			C_BIT_CNT				= 12'h364
	)(
 	// Global Signal
	input               CLK_100M        , 						// System Clock 100MHz
	input               IO_RESET        , 						// ASY System Reset

	// UART Interface
    output              UART_TXD		, 						// UART Output Data
    input               UART_RXD		, 						// UART Iutput Data

	// DRAM_IO Interface
	input	[511:0]		DRAM_RDATA		, 						// (i) FPGA Configuration Data Request
	input				DRAM_RD_VLD		, 						// (i) FPGA Configuration One Group Data End Flag(256 Data For One Group)
	output				UART_TRAN_BUSY	, 						// (o) FPGA Configuration Status(0:No Data, 1:Have Data)

	// PARAM_IO Interface
	output				REG_WE			,						// Write Enable Register
	output				REG_RE			,						// Read enable register.
	output	[15:0]		REG_AD			,						// Register Address
	output	[31:0]		REG_WD			,						// Register Write Data
	input				REG_RDVLD		, 						// Register Read Data valid
	input	[31:0]		REG_RD									// Register Read Data

	) ;

	// =============================================================================
	// Signal Define
	// =============================================================================
	wire				s_UART_RX_COMPLETE				; 
	wire				s_UART_TX_COMPLETE				; 
	wire				s_UART_TX_EN					; 
	wire	[7:0]		s_UART_RX_DATA					; 
	wire	[7:0]		s_UART_TX_DATA					; 
	
	uart_tx	# (
    	.C_BIT_CNT			( C_BIT_CNT				)
    	)	u_uart_tx (
		// Global Signal
		.CLK_100M			( CLK_100M				) , // (i) System Clock 100MHz
		.IO_RESET			( IO_RESET				) , // (i) ASY System Reset
		
		.UART_TXD			( UART_TXD				) , // (o) UART Output Data
		.UART_TX_DATA		( s_UART_TX_DATA		) , // (i) UART TX Data
		.UART_TX_COMPLETE	( s_UART_TX_COMPLETE	) , // (o) UART 8Bit Data TX Complete
		.UART_TX_EN			( s_UART_TX_EN			)   // (i) UART TX Enable	
	) ;                                                        

	uart_rx	# (
    	.C_BIT_CNT			( C_BIT_CNT				)
    	)	u_uart_rx (
		// Global Signal
		.CLK_100M			( CLK_100M				) , // (i) System Clock 100MHz
		.IO_RESET			( IO_RESET				) , // (i) ASY System Reset
		
		.UART_RXD			( UART_RXD				) , // (i) UART Iutput Data
		.UART_RX_COMPLETE	( s_UART_RX_COMPLETE	) , // (o) UART RX 1 Byte Data Complete
		.UART_RX_DATA		( s_UART_RX_DATA		)   // (o) UART Receiving Data
	) ;
	
    uart_ctrl		u_uart_ctrl (
    	// Global Signal
    	.CLK_100M			( CLK_100M				) ,	// (i) Clock 100MHz
		.IO_RESET			( IO_RESET				) ,	// (i) Async. Reset (Low Active)
		
		// RX
		.UART_RX_COMPLETE	( s_UART_RX_COMPLETE	) ,	// (i) EPC Address
		.UART_RX_DATA		( s_UART_RX_DATA		) ,	// (i) ERC Byte Enable
		
		// TX
		.UART_TX_COMPLETE	( s_UART_TX_COMPLETE    ) ,	// (i) K7 Config End
		.UART_TX_DATA		( s_UART_TX_DATA    	) ,	// (o) K7 Config Done		
		.UART_TX_EN			( s_UART_TX_EN			) ,	// (o) V5 Config Done
		
		// DRAM_IO Interface
		.IO_DRAM_RDATA 		( DRAM_RDATA 			) ,	// (i) Flash Ready
		.IO_DRAM_RD_VLD		( DRAM_RD_VLD			) ,	// (i) Buffer Ready
		.UART_TRAN_BUSY		( UART_TRAN_BUSY		) , // (o) Verify Data Clear
		
		// PARAM_IO Interface
		.REG_WE				( REG_WE				) ,	// (o) Board Select
		.REG_RE				( REG_RE			    ) ,	// (o) FPGA Config Start
		.REG_AD				( REG_AD				) , // (o) V5 Config Status		
		.REG_WD				( REG_WD			   	) ,	// (o) Flash Sector Address(For Erase)
		.REG_RDVLD			( REG_RDVLD				) , // (i) Register Read Data valid
		.REG_RD				( REG_RD			    ) 	// (i) Flash Write Start
	) ;
	
endmodule
