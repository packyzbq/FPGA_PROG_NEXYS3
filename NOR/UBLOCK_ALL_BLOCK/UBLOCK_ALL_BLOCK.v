`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:50:00 04/23/2013 
// Design Name: 
// Module Name:    UBLOCK_ALL_BLOCK 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: UNLOCK ALL THE BLOCK IN NOR FLASH
//						UNLOCK ALL THE BLOCK SUCCEED
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module UBLOCK_ALL_BLOCK( CLK,
								 RESET,
								 WE,
								 CE,
								 OE,
								 ADDR,
								 LED,
								 SHOW,
								 DATA
								 
    );
	 input CLK;
	 input RESET;
	 output WE;
	 output CE;
	 output OE;
	 output[23:0] ADDR;
	 output LED;
	 inout[15:0] DATA;
	 output[7:0] SHOW;  
	 
	 reg WE = 'b1;							//THE SIGNAL TO ENABLE WRITE OPERATION
	 reg CE = 'b1;							//THE SIGNAL TO ENABLE THE CHIP
	 reg OE = 'b1;							//THE SIGNAL TO ENABLE THE READ OPERATION
	 reg[23:0] ADDR = 'h000000;		//THE ADDRESS TO BE UNLOCKED
	 reg LED = 'b1;						//ONCE UNLOCK SUCCEED,LED UNLIGHT
	 reg[7:0] SHOW = 'h00;				//WHEN ERASED ALL,READ THE LAST BLOCK ID
	 reg[15:0] CMD_RD = 'h0090;		//THE COMMAND TO READ THE ID
	 reg[15:0] CMD_US = 'h0060;		//THE COMMAND TO BLOCK LOCK SETUP
	 reg[15:0] CMD_UL = 'h00d0;		//THE COMMAND TO UNLOCK THE BLOCK
	 reg[7:0] ID_LOCK = 'h02;			//THE ADDRESS OF THE LOCK INFORMATION OF ONE BLOCK
	 reg[7:0] C_STATE = 'd0;			//THE STATUS TO CONTROL THE MACHINE
	 reg[3:0] BLOCK_16_COUNT = 'd3;	//USED TO IDENTIFY THE 16KB BLOCK; 4 BLOCK IN TOTAL  
	 reg[7:0] BLOCK_64_COUNT = 'd255;//USED TO IDENTIFY THE 64KB BLOCK; 254 BLOCK IN TOTAL  
	 reg[15:0] COUNT = 'd0;						//USED TO IDENTIFY THE OP BLOCK 
	 
	 
	 assign DATA = ((C_STATE > 'd4) && (C_STATE < 'd8)) ? CMD_US : 
						((C_STATE > 'd7) && (C_STATE < 'd11)) ? CMD_UL : 
						((C_STATE > 'd12) && (C_STATE < 'd16)) ? CMD_RD : 'hzz;			//TO BE CHANGED
	 
	 
	 always @(posedge CLK)
	 begin
	 /*FIRST DEAL WITH THE RESET SIGNAL*/
	 if(RESET)
		begin
		CE <= 'b1;
		WE <= 'b1;
		OE <= 'b1;
		ADDR <= 'h000000;
		SHOW <= 'h00;
		C_STATE <= 'd0;
		end
		
		/*THEN GOES INTO THE STATUS MACHINE*/
	 case(C_STATE)
		/*WAIT AT LEAST 150ns BEFORE WRITE OPERATION AFTER RESET THE NOR FLASH*/
		'd0 : C_STATE <= 'd1;
		'd1 : C_STATE <= 'd2;
		'd2 : C_STATE <= 'd3;
		'd3 : C_STATE <= 'd4;
		'd4 : C_STATE <= 'd5;
		/*FIRST WRITE THE CMD CMD_US, HOLD FOR 50ns*/
		'd5 : 
		begin
		CE <= 'b0;
		WE <= 'b0;
		//ADDR <= (ADDR || ID_LOCK);
		C_STATE <= 'd6;
		end
		'd6 : C_STATE <= 'd7;
		/*THE FIRST CYCLE IS END , THEN DEASSERT THE SIGNAL CE FOR NEXT CYCLE*/
		'd7 : 
		begin
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd8;
		end
		/*WE HIGH TO LOW JUST NEED 20ns*/
		/*THE SECOND CYCLE, THE COMMAND IS D0 , CONFIRM THE UNLOCK OPERATION*/
		'd8 :
		begin
		CE <= 'b0;
		WE <= 'b0;
		C_STATE <= 'd9;
		end
		'd9 : C_STATE <= 'd10;
		'd10 : 
		begin
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd11;
		end
		'd11 : C_STATE <= 'd12;
		/*CHANGE THE OP ADDRESS HERE, ACCORDING TO THE BLOCK_16_COUNT AND THE BLOCK_64_COUNT*/
		'd12 : 
		begin
		if(COUNT < 4)
			begin
			ADDR <= ADDR + 'h004000;
			COUNT <= COUNT+1;
			C_STATE <= 'd4;			// d4 or d5????
			end
		else if(COUNT < 259)
			begin
			ADDR <= ADDR + 'h010000;
			COUNT <= COUNT+1;
			C_STATE <= 'd4;			// d4 or d5????
			end
		else
			begin
			LED <= 'b0;
			//COUNT <= 'd0;
			C_STATE <= 'd12;
			end
		end
		/*COMPLETED THE UNLOCK OPERATION, READ THE IN TO CHECK WHETHER UNLOCK SUCCEED OR NOT*/
		/*FIRST WRITEH THE READ ID COMMAND 0X90*/
		'd13 : 
		begin
		CE <= 'b0;
		WE <= 'b0;
		ADDR <= 'h020000;
		C_STATE <= 'd14;
		end
		'd14 : C_STATE <= 'd15;
		'd15 : 
		begin
		CE <= 'b1;
		WE <= 'b1;
		C_STATE <= 'd16;
		end
		'd16 : 
		begin
		CE <= 'b0;
		OE <= 'b0;
		ADDR <= (ADDR + ID_LOCK);
		C_STATE <= 'd17;
		end
		'd17 : C_STATE <= 'd18;
		'd18 : C_STATE <= 'd19;
		'd19 : C_STATE <= 'd20;
		'd20 : 
		begin
		SHOW[7:0] <= DATA[7:0];
		C_STATE <= 'd21;
		end
		'd21 : 
		begin
		CE <= 'b1;
		OE <= 'b1;
		C_STATE <= 'd21;
		end
		
		default : C_STATE <= 'd0;
	 endcase
	 end
endmodule
