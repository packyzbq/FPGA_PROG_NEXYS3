`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:12 04/20/2013 
// Design Name: 
// Module Name:    RD_LOCK_STATUS 
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
module RD_LOCK_STATUS( CLK,
							  ADDR,
							  SHOW,
							  DATA,
							  WE,
							  CE,
							  RESET,
							  OE
    );
	 input CLK;				//THE CLOCK
	 input RESET;			//THE RESET KEY
	 output[7:0] SHOW;	//USED TO SHOW THE RESULT
	 output CE;				//THE SIGNAL TO CHOSE THE CHIP
	 output WE;				//THE SIGNAL TO ENABLE WRITE
	 output OE;				//THE SIGNAL TO ENABLE READ
	 output[23:0] ADDR;	//THE WRITE/READ ADDRESS
	 inout[15:0] DATA;	//THE DATA OR COMMAND TO READ OR WRITE 
	 
	 
	 /*
	 //THE REG TO DRIVE WIRE OR COMMAND
	 */
	 reg WE = 'b1;
	 reg CE = 'b1;
	 reg OE = 'b1;
	 reg[23:0] ADDR = 'h3f0000;
	 reg[7:0] SHOW = 'h00;
	 reg[15:0] CMD = 'h0090;			//THE COMMAND TO READ THE READ ID
	 reg[7:0] C_STATE = 'd0;		//TO IDENTIFIY THE STATE
	 
	 assign DATA = ((C_STATE > 'd4) &&(C_STATE < 'd8)) ? CMD : 'hzz; 
	 
	 always @(posedge CLK)
	 begin
	 /*
	 //IF THE KEY RESET IS PRESSED
	 */
	 if(RESET)
	 begin
		CE <= 'b1;
		WE <= 'b1;
		OE <= 'b1;
		SHOW <= 'h00;
		C_STATE <= 'd0;
	 end
	 else
	 /*
	 //DO OPERATION ACCORDDING TO THE SEQUENCE TABLE
	 */
	 begin
	 case(C_STATE)
		'd0: C_STATE <= 'd1;
		'd1: C_STATE <= 'd2;
		'd2: C_STATE <= 'd3;
		'd3: C_STATE <= 'd4;
		'd4: C_STATE <= 'd5;
		/*
		//WRITE THE CMD HERE
		*/
		'd5: begin
			CE <= 'b0;
			WE <= 'b0;
			//ADDR <= 'h020000;
			C_STATE <= 'd6;
			end
		'd6: C_STATE <= 'd7;
		'd7: begin
			CE <= 'b1;
			WE <= 'b1;
			C_STATE <= 'd8;
			end
		'd8: C_STATE <= 'd9;
		'd9: begin
			CE <= 'b0;
			OE <= 'b0;
			//ADDR <= (ADDR || 'h000002);
			C_STATE <= 'd10;
			end
		'd10: C_STATE <= 'd11;
		'd11: C_STATE <= 'd12;
		'd12: C_STATE <= 'd13;
		'd13: begin
			SHOW[7:0] <= DATA[7:0];
			C_STATE <= 'd14;
			end
		'd14: begin
			C_STATE <= 'd14;
			CE <= 'b1;
			OE <= 'b1;
			//ADDR <= 'h000000;
			end
		default: C_STATE <= 'd0;
	 endcase
	 end
	 
	 
	 end
	 
	 
		


endmodule
