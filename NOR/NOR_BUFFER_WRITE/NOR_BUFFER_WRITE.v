`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:06 05/03/2013 
// Design Name: 
// Module Name:    NOR_BUFFER_WRITE 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//		BUFFER WRITE SUCCEED BUT DO NOT GET THE PROGRAM TIME	
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NOR_BUFFER_WRITE(CLK,
								RESET,
								CE,
								WE,
								OE,
								ADDR,
								SHOW,
								DATA
    );
	 input CLK;
	 input RESET;
	 output CE;
	 output WE;
	 output OE;
	 output[23:0] ADDR;
	 output[7:0] SHOW;
	 inout[15:0] DATA;
	 
	 /*THE PARAMATERS HERE*/
	 parameter BUFF_PR_CMD = 'h00e8;
	 parameter P_S_DATA = 'h52; 				//THE START DATA TO BE PROGRAMED
	 parameter WR_CON = 'h00d0;
	 parameter COUNT = 3;
	 
	 /**REGS DEFINE HERE**/
	 reg CE = 'b1;
	 reg OE = 'b1;
	 reg WE = 'b1;
	 reg[23:0] ADDR = 'h3f0000;
	 reg[7:0] SHOW = 'h00;
	 reg[7:0] C_STATE = 'd0;
	 reg RW = 'b1;
	 reg[15:0] CMD;
	 reg[32:0] PRO_COUNT = 'd0;
	 
	 assign DATA = RW ? 'hzzzz : CMD;
	 
	 always @(posedge CLK)
	 begin
		if(RESET)
		begin
		CE <= 'b1;
		WE <= 'b1;
		OE <= 'b1;
		ADDR <= 'h3f0000;
		SHOW <= 'h00;
		RW <= 'b1;
		CMD <= 'hzzzz;
		C_STATE <= 'd0;
		end
		else
		begin
		//AFTER THE ERASE, DO THE BUFFER WRITE RIGHT NOW
		case(C_STATE)
		'd0 : 				//WRITE THE BUFFER PROGRAM SETUP COMMAND
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= BUFF_PR_CMD;
		C_STATE <= 'd1;
		end
		'd1 : C_STATE <= 'd2;
		'd2 : 
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd3;
		end
		'd3 : 			//READ THE STATUS REGISTER
		begin
		CE <= 'b0;
		OE <= 'b0;
		C_STATE <= 'd4;
		end
		'd4 : C_STATE <= 'd5;
		'd5 : C_STATE <= 'd6;
		'd6 : C_STATE <= 'd7;
		'd7 :
		begin
		SHOW[7:0] <= DATA[7:0];
		C_STATE <= 'd8;
		end
		'd8 : 
		begin
		CE <= 'b1;
		OE <= 'b1;
		if(SHOW[7] == 1)
		begin
		C_STATE <= 'd9;
		SHOW[7:0] <= 'h00;
		end
		else
		begin
		C_STATE <= 'd7;
		end
		
		end
		'd9 :			//WRITE THE WORD COUNT TO BE WRITEN
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= COUNT;
		ADDR <= 'h3f0000;
		C_STATE <= 'd10;
		end
		'd10 : C_STATE <= 'd11;
		'd11 : 
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd12;
		end
		'd12 :							//WRITE THE FIRST DATA AND ADDR
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= P_S_DATA;
		ADDR <= 'h3f0000;
		C_STATE <= 'd13;
		end
		'd13 : C_STATE <= 'd14;
		'd14 :
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd15;
		end
		
		'd15 :							//WRITE THE SECOND DATA AND ADDR
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= P_S_DATA + 1;
		ADDR <= 'h3f0002;
		C_STATE <= 'd16;
		end
		'd16 : C_STATE <= 'd17;
		'd17 :
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd18;
		end		
		
		'd18 :							//WRITE THE THIRD DATA AND ADDR
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= P_S_DATA + 2;
		ADDR <= 'h3f0004;
		C_STATE <= 'd19;
		end
		'd19 : C_STATE <= 'd20;
		'd20 :
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd21;
		end	

		'd21 :							//WRITE THE FORTH DATA AND ADDR
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= P_S_DATA +3 ;
		ADDR <= 'h3f0006;
		C_STATE <= 'd22;
		end
		'd22 : C_STATE <= 'd23;
		'd23 :
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd24;
		end	
		
		//WRITE THE BUFFER WRITE CONFIRM COMMAND
		'd24 : 
		begin
		RW <= 'b0;
		CE <= 'b0;
		WE <= 'b0;
		CMD <= WR_CON;
		ADDR <= 'h3f0000;
		C_STATE <= 'd25;
		end
		'd25 : C_STATE <= 'd26;
		'd26 : 
		begin
		RW <= 'b1;
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd27;
		end
		//WAIT FOR THE BUFFER WRITE; WAIT FOR 
		'd27 :
		begin
		if(PRO_COUNT <= 100000)
			begin
			PRO_COUNT <= PRO_COUNT +1;
			C_STATE <= 'd27;
			end
		else
			begin
			PRO_COUNT <= 'd0;
			C_STATE <= 'd28;
			end
		end
		
		//READ THE STATUS REGISTER
		'd29 :
		begin
		CE <= 'b0;
		OE <= 'b0;
		C_STATE <= 'd30;
		end
		'd30 : C_STATE <= 'd31;
		'd31 : C_STATE <= 'd32;
		'd32 : C_STATE <= 'd33;
		'd33 : 
		begin
		SHOW[7:0] <= DATA[7:0];
		C_STATE <= 'd34;
		end
		'd34 :
		begin
		CE <= 'b1;
		OE <= 'b1;
		C_STATE <= 'd29;
		end
		
		default : C_STATE <= 'd34;
		
		
		endcase
		end
		
		
	 end


endmodule
