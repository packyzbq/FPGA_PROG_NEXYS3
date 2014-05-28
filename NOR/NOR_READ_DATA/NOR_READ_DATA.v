`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:56:45 05/02/2013 
// Design Name: 
// Module Name:    NOR_READ_DATA 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: USED FOR THE READ OPERATON
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NOR_READ_DATA(CLK,
							RESET,
							CE,
							WE,
							OE,
							ADDR,
							DATA,
							SHOW
    );
	 
	 /*INPUT/OUTPUT DEFINES HERE*/
	 input CLK;
	 input RESET;
	 output CE;
	 output WE;
	 output OE;
	 output[23:0] ADDR;
	 output[7:0] SHOW;
	 inout[15:0] DATA;
	 
	 /*REGS DEFINES HERE*/
	 reg CE = 'b1;
	 reg OE = 'b1;
	 reg WE = 'b1;
	 reg[23:0] ADDR = 'h3f0002;
	 reg[7:0] SHOW = 'h00;
	 reg[15:0] CMD = 'h00ff;
	 reg[7:0] C_STATE = 'd0;
	 
	 //assign DATA = CMD;
	 
	 /*LOGIC BEGINS HERE*/
	 
	 always @(posedge CLK)
	 begin
	 if(RESET)
	 begin
	 CE <= 'b1;
	 WE <= 'b1;
	 OE <= 'b1;
	 SHOW <= 'h00;
	 ADDR <= 'h3f0002;
	 C_STATE <= 'd0;
	 end
	 else
	 begin
	 case(C_STATE)
	 'd0 : 
		begin
		CE <= 'b0;
		OE <= 'b0;
		WE <= 'b1;
		ADDR <= 'h3f0002;
		C_STATE <= 'd1;
		end
	 'd1 : C_STATE <= 'd2;
	 'd2 : C_STATE <= 'd3;
	 'd3 : C_STATE <= 'd4;
	 'd4 :
		begin
		SHOW[7:0] <= DATA[7:0];
		C_STATE <= 'd5;
		end
	 'd5 :
		begin
		CE <= 'b0;
		OE <= 'b0;
		C_STATE <= 'd5;
		end
	 
	 default : C_STATE <= 'd0;	 
	 endcase
	 end
	 end
	 


endmodule
