`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:45 04/20/2013 
// Design Name: 
// Module Name:    USE_RD_LOCK_STATUS 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: DONE THE MODULE; CALL THE RD_LOCK_STATUS AS THE CHILD MODULE
//					LET THE PIN DATA OF RD_LOCK_STATUS AS INPUT
//					WHEN USE THE RD_LOCK_STATUS, JUST CALL IT
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module USE_RD_LOCK_STATUS( CLK,
									ADDR,
									SHOW,
									DATA,
									WE,
									CE,
									RESET,
									OE
    );
	 input CLK;
	 input RESET;
	 output[23:0] ADDR;
	 output[7:0] SHOW;
	 //reg[23:0] ADDRREG = 'h3f0002;
	 output WE;
	 output CE;
	 output OE;
	 inout[15:0] DATA;
	 
	 wire ADDR_M;
	 
	 
	 RD_LOCK_STATUS RD(
	 .CLK(CLK),
	 .ADDR(ADDR_M),
	 .SHOW(SHOW),
	 .DATA(DATA),
	 .WE(WE),
	 .CE(CE),
	 .OE(OE),
	 .RESET(RESET)
	 );
	 assign ADDR = ADDR_M;


endmodule
