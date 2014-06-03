`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:14:04 07/03/2013 
// Design Name: 
// Module Name:    pcm_word_program_50MHz 
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
module pcm_word_program_50MHz(
           clk,
			  addr,data,
			  rst_n,ce_n,oe_n,we_n,
			  led,key
    );
	 
	 //mmu interface
	 input clk;                         //100MHz
	 input [2:0] key;                   //key for rst_n,read,write
	 output [3:0] led;
	 
	 //pcm interface
	 output [22:0] addr;
	 inout [15:0] data;
	 output rst_n;
	 output ce_n;
	 output oe_n;
	 output we_n;
	 
	 reg [3:0] ledr;
	 reg [15:0] datar;
	 reg [22:0] addrp;
	 reg rst;
	 reg ce;
	 reg oe;
	 reg we;
	 reg rw;
	 reg [1:0] q;
	 reg clkp;
	 always @ (posedge clk)
	 begin
	 q <= q+2'b1;
	 clkp <= q[0];
	 end
	 
	 assign rst_n = rst;
	 assign ce_n = ce;
	 assign oe_n = oe;
	 assign we_n = we;
	 assign addr = addrp;
	 assign led = ledr;
	 assign data = rw ? 16'hzzzz : datar;
	 
	 reg [7:0] cs;                  //current state
	 
	 always @ (posedge clkp)
	 begin
	 if (key[2])
	 begin
	 rst <= 1'b0;
	 cs <= 'd0;
	 end
	 else if ((~key[0] && ~key[1]) || (key[0] && key[1]))
	 begin
	 cs <= 'd0;
	 end
	 else
	 begin
	 case (cs)
	 'd0:begin
	     rst <= 1'b1;
		  ce <= 1'b1;
		  oe <= 1'b1;
		  we <= 1'b1;
	     cs <= 'd1;
		  end
    'd1:cs <= 'd2;
	 'd2:cs <= 'd3;
	 'd3:cs <= 'd4;
	 'd4:cs <= 'd5;
	 'd5:cs <= 'd6;
	 'd6:cs <= 'd7;
	 'd7:cs <= 'd8;
	 
	 'd8:if (key[0] && ~key[1])             //word program or bit-alterable word write
	     cs <= 'd21;
		  else if (key[1] && ~key[0])        //read array
		       cs <= 'd9;
		  else
		  cs <= 'd0;

	 'd9:begin
	      ce <= 1'b0;
			we <= 1'b0;
			rw <= 1'b0;
	      addrp <= 23'h000fff;
			datar <= 16'h00ff;
	      cs <= 'd10;
			end
	 'd10:cs <= 'd11;
	 'd11:cs <= 'd12;
	 'd12:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd13;
			end
	 'd13:begin
	      ce <= 1'b0;
			oe <= 1'b0;
			rw <= 1'b1;
	      addrp <= 23'h000fff;
	      cs <= 'd14;
			end
	 'd14:cs <= 'd15;
	 'd15:cs <= 'd16;
	 'd16:cs <= 'd17;
	 'd17:cs <= 'd18;
	 'd18:cs <= 'd19;
	 'd19:begin
	      ledr <= data[3:0];
	      cs <= 'd20;
			end
	 'd20:begin
	      ce <= 1'b1;
			oe <= 1'b1;
	      cs <= 'd48;
			end
			
	 'd21:begin                    //unlock
	      ce <= 1'b0;
			we <= 1'b0;
			rw <= 1'b0;
	      addrp <= 23'h000fff;
			datar <= 16'h0060;
	      cs <= 'd22;
			end
	 'd22:cs <= 'd23;
	 'd23:cs <= 'd24;
	 'd24:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd25;
			end
	 'd25:cs <= 'd26;
	 'd26:begin
	      ce <= 1'b0;
			we <= 1'b0;
	      addrp <= 23'h000fff;
			datar <= 16'h00d0;
	      cs <= 'd27;
			end
	 'd27:cs <= 'd28;
	 'd28:cs <= 'd29;
	 'd29:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd30;
			end
	 'd30:cs <= 'd31;
	 'd31:begin                  //write
	      ce <= 1'b0;
			we <= 1'b0;
	      addrp <= 23'h000fff;
			//datar <= 16'h0040;
			datar <= 16'h0042;
	      cs <= 'd32;
			end
	 'd32:cs <= 'd33;
	 'd33:cs <= 'd34;
	 'd34:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd35;
			end
	 'd35:cs <= 'd36;
	 'd36:begin
	      ce <= 1'b0;
			we <= 1'b0;
	      addrp <= 23'h000fff;
			datar <= 16'h000a;
	      cs <= 'd37;
			end
	 'd37:cs <= 'd38;
	 'd38:cs <= 'd39;
	 'd39:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd40;
			end
	 'd40:begin                  //read status
	      ce <= 1'b0;
			oe <= 1'b0;
			rw <= 1'b1;
	      addrp <= 23'h000fff;
	      cs <= 'd41;
			end
	 'd41:cs <= 'd42;
	 'd42:cs <= 'd43;
	 'd43:cs <= 'd44;
	 'd44:cs <= 'd45;
	 'd45:cs <= 'd46;
	 'd46:begin
	      ledr <= data[3:0];
	      cs <= 'd47;
			end
	 'd47:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd48;
			end
	 'd48:cs <= 'd48;

	 default:cs <= 'd0;
	 endcase	 
	 end	 
	 end
	 
endmodule


