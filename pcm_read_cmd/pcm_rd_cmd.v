`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:17 05/28/2014 
// Design Name: 
// Module Name:    pcm_rd_cmd 
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
module pcm_rd_cmd(
clk,
	rst_n,
	sw,
	cs,
	oe,
	we,
	memrst,
	addr,
	data,
	led
    );
	 
input clk,rst_n,sw;
output cs,oe,we,memrst;
output [24:1] addr;
output [7:0] led;
inout [15:0] data;

reg cs = 'b1;
reg oe = 'b1;
reg we = 'b1;
reg [7:0] led = 'h00;
reg [7:0] state = 'd0;
reg [24:0] addr = 'h100000;
reg [7:0] idle = 'd6;
reg CMD = 'hff;

assign memrst = 'b1;
assign data = (state < 'd3 && state >= 'd0)? CMD:'hzzzz;
//assign addr = 'h100000;

always@(posedge clk)
begin
	if(!rst_n)
	begin
		cs <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		addr <= 'h100000;
		led <= 'h00;
	end
	else
	begin
		case(state)
		'd0:
		begin
			if(sw)
				state <= 'd1;
			else
				state <= 'd0;
		end
		'd1:
		begin
			cs <= 'b0;
			oe <= 'b1;
			we <= 'b0;
			addr <= 'h100000;
			if(idle == 0)
			begin
				state <= 'd2;
				idle <= 'd12;
			end
			else
			begin
				idle <= idle - 'd1;
				state <= 'd1;
			end
		end
		'd2:
		begin
			cs <= 'b1;
			oe <= 'b1;
			we <= 'b1;
			led <= 'h00;
			
			state <= 'd3;
		end
		'd3:
		begin
			addr <= 'h100000;
			cs <= 'b0;
			oe <= 'b0;
			we <= 'b1;
			if(idle == 0)
			begin
				state <= 'd4;
				led[7:0] <= data[7:0];
				idle <= 'd10;
			end
			else
			begin
				idle <= idle - 'd1;
				state <= 'd3;
			end
			end
		'd4:
		begin
			cs <= 'b1;
			oe <= 'b1;
			we <= 'b1;
			if(!sw)
				state <= 'd0;
			else
				state <= 'd4;
		end
		default:
			state <= state;
		endcase
	end
end



endmodule


