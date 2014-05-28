`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:19:06 04/19/2013 
// Design Name: 
// Module Name:    USE_RD_LOCK 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module USE_RD_LOCK( CLK,
						  ADDR,
						  DATA,
						  WE,
						  CE,
						  OE,
						  SHOW
    );
	 
	 /*DEFINE THE INPUT/OUTPUT HERE*/
	 input CLK;
	 output[23:0] ADDR;
	 output[7:0] SHOW;
	 output WE;
	 output CE;
	 output OE;
	 inout[15:0] DATA;
	 //reg[3:0] count = 'd5;
	 
	 
	 /*DEFINE THE REGS HERE*/
	 
	 //reg[23:0] ADDRR = 'h020000;
	// reg[7:0] SHOW = 'h0000;
	// reg WE = 'b1;
	// reg CE = 'b1;
	// reg OE = 'b1;
	//assign ADDR = ADDRR;
	 
	 /*OPERATION STARTS HERE, READ TO DETERMINE WHETHER THE BLOCK IS LOCKED OR NOT */
	 
	 RD_LOCK rd_lock(
	 .CLK(CLK),
	 .ADDR(ADDR),
	 .DATA(DATA),
	 .SHOW(SHOW),
	 .CE(CE),
	 .OE(OE),
	 .WE(WE)
	 );
	
	
endmodule
