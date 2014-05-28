`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:09:32 04/19/2013 
// Design Name: 
// Module Name:    RD_LOCK 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  USED TO CHECK BLOCK THE ADDR DETERMINES IS LOCKED OR NOT
//		DO THE EXAMINE ONCE A TIME; USE THE FOR LOOP TO DO 
// Dependencies: 
//
// Revision: V1
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RD_LOCK(CLK,
					ADDR,
					DATA,
					SHOW,
					CE,
					WE,
					OE
    );
	 /*
	 // DEFINE THE INPUT/OUPUT HERE
	 */
	 input CLK;
	 output[23:0] ADDR;
	 output[7:0] SHOW;
	 output CE;
	 output WE;
	 output OE;
	 inout[15:0] DATA;
	 
	 /*
	 //DEFINE THE REGS AND DRIVE THE WIRE
	 */
	 //reg[23:0] ADDR;				//THE ADDRESS FOR THE READ OPERATION
	 reg CE = 'b1;					//THE SIGNAL CE;USED TO ENABLE THE CHIP
	 reg WE = 'b1;					//THE SIGNAL WE;USED TO ENABLE WRITE
	 reg OE = 'b1;					//THE SIGNAL OE;USED TO ENABLE READ
	 reg[7:0] SHOW = 'h0000;	//USED TO SHOW THE RESULT
	 reg CMD = 'h0090;			//COMMAND;USED TO READ THE IDENTIFIER
	 reg[7:0] C_STATE ='d0; 	//THE STATION USED DURING THE OPERATION
	 reg[23:0] ADDR = 'h020000; 
	 //reg[4:0] count = 0;			//USED TO CONTORL THE FOR LOOP 
	 
	 /*
	 //DEFINE THE DATA; DISTINGUISH THE INPUT AND OUTPUT
	 */
	 assign DATA = ((C_STATE < 'd4) && (C_STATE >= 'd0))? CMD:'hzz;
	 
	 /*
	 //THE OPERATION STARTS HERE
	 */
	 
	 always @(posedge CLK)
	 begin
	 /*
	 //THE OP CHANGE ACCORDDING TO THE C_STATE
	 */
		case(C_STATE)
			'd0: begin
				CE <= 'b0;
				WE <= 'b0;
				OE <= 'b1;
				C_STATE <= 'b1;
			end
			'd1: C_STATE <= 'd2;
			'd2: begin
				CE <= 'b1;
				WE <= 'b1;
				C_STATE <= 'd3;
			end
			'd3: C_STATE <= 'd4;
			'd4: begin
				CE <= 'b0;
				OE <= 'b0;
				ADDR <= (ADDR || 'h000002);
				C_STATE <= 'd5;
			end
			// HOLE THE CE,ADDRESS FOR 110NS
			'd5: C_STATE <= 'd6;
			'd6: C_STATE <= 'd7;
			'd7: C_STATE <= 'd8;
			'd9: begin
				SHOW[7:0] <= DATA[7:0];
				C_STATE <= 'd10;
			end
			// Q: HOW TO LET THE MODULE EXCUTE ONLY ONCE AND HOW TO EXIT THE MOUDLE USE THE LOOP FOR TO TEST
			'd10: C_STATE <= 'd11;
			default: C_STATE <= 'd0;
			
		endcase
	 end
	
endmodule
