`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:31:50 05/10/2013 
// Design Name: 
// Module Name:    pcm_read_id 
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
module pcm_read_id(
           clk,
			  addr,data,
			  rst_n,ce_n,oe_n,we_n,
			  sw,led,key
    );
	 
	 //mmu interface
	 input clk;
	 input [2:0] key;                   //key for rst_n,read,write
	 input [7:0] sw;
	 output [7:0] led;
	 
	 //pcm interface
	 output [22:0] addr;
	 inout [15:0] data;
	 output rst_n;
	 output ce_n;
	 output oe_n;
	 output we_n;
	 
	 reg [7:0] ledr;
	 reg [15:0] datar;
	 reg [22:0] addrp;
	 reg rst;
	 reg ce;
	 reg oe;
	 reg we;
	 reg rw;
	 
	 assign rst_n = rst;
	 assign ce_n = ce;
	 assign oe_n = oe;
	 assign we_n = we;
	 assign addr = addrp;
	 assign led = ledr;
	 assign data = rw ? 16'hzzzz : datar;
	 
	 reg [7:0] cs;                  //current state
	 
	 always @ (posedge clk)
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
	 'd0:if (key[0] && ~key[1])
	     cs <= 'd38;
		  else if (key[1] && ~key[0])        //read id
		       cs <= 'd1;
		  else
		  cs <= 'd0;

    'd1:begin
	     rst <= 1'b1;
		  ce <= 1'b1;
		  oe <= 1'b1;
		  we <= 1'b1;
	     cs <= 'd2;
		  end
	 'd2:cs <= 'd3;
	 'd3:cs <= 'd4;
	 'd4:cs <= 'd5;
	 'd5:cs <= 'd6;
	 'd6:cs <= 'd7;
	 'd7:cs <= 'd8;
	 'd8:cs <= 'd9;
	 'd9:cs <= 'd10;
	 'd10:cs <= 'd11;
	 'd11:cs <= 'd12;
	 'd12:cs <= 'd13;
	 'd13:cs <= 'd14;
	 'd14:cs <= 'd15;
	 'd15:cs <= 'd16;
	 'd16:begin
	      ce <= 1'b0;
			we <= 1'b0;
			rw <= 1'b0;
	      addrp <= {15'h0000,sw};
			datar <= 16'h0090;
	      cs <= 'd17;
			end
	 'd17:cs <= 'd18;
	 'd18:cs <= 'd19;
	 'd19:cs <= 'd20;
	 'd20:cs <= 'd21;
	 'd21:cs <= 'd22;
	 'd22:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd23;
			end
	 'd23:begin
	      ce <= 1'b0;
			oe <= 1'b0;
			rw <= 1'b1;
	      addrp <= {15'h0000,sw};
	      cs <= 'd24;
			end
	 'd24:cs <= 'd25;
	 'd25:cs <= 'd26;
	 'd26:cs <= 'd27;
	 'd27:cs <= 'd28;
	 'd28:cs <= 'd29;
	 'd29:cs <= 'd30;
	 'd30:cs <= 'd31;
	 'd31:cs <= 'd32;
	 'd32:cs <= 'd33;
	 'd33:cs <= 'd34;
	 'd34:cs <= 'd35;
	 'd35:cs <= 'd36;
	 'd36:begin
	      ledr <= data[7:0];
	      cs <= 'd37;
			end
	 'd37:begin
	      ce <= 1'b1;
			oe <= 1'b1;
	      cs <= 'd38;
			end
	 'd38:cs <= 'd38;
	 
	 default:cs <= 'd0;
	 endcase	 
	 end	 
	 end
	 
endmodule
