`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:33 05/29/2014 
// Design Name: 
// Module Name:    pcm_unlock_prog_rdreg 
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
module pcm_unlock_prog_rdreg(
	clk,
	rst_n,
	ce,
	oe,
	we,
	memrst,
	addr,
	data,
	sw,
	led
    );

input clk,rst_n,sw;
output ce,oe,we,memrst;
output [24:1] addr;
output [7:0] led;
inout [15:0] data;

reg ce = 'b1;
reg oe = 'b1;
reg we = 'b1;
reg [7:0] state = 'd0;
reg [24:1] addr = 'h100000;
reg [7:0] led = 'h00;
reg [7:0] idle = 'd6;

parameter unlock_1 = 'h60;
parameter unlock_2 = 'hD0;
parameter prog_1 = 'h40;
parameter rdreg_1 = 'h70;
parameter rd_time = 'd10;
parameter wr_time = 'd5;

assign memrst = 'b1;
assign data = (state <'d3 && state >= 'd1)? unlock_1:
					((state <'d6) && (state >= 'd3)) ? unlock_2:
					((state >= 'd6) &&(state < 'd9)) ? rdreg_1:
					((state < 'd12) && (state >= 'd10)) ? 'hzzzz:
					((state >= 'd13) && (state < 'd15)) ? prog_1:
					((state >= 'd16) && (state < 'd18)) ? 'h5552 : 'hzzzz;
					

always@(posedge clk)
begin
	if(!rst_n)
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		state <= 'd0;
		led <= 'h00;
	end
	else
	case(state)
	'd0:
	begin
		led <= 'h00;
		if(sw)
			state <= 'd1;
		else
			state <= 'd0;
	end
	//unlock_1
	'd1:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		addr <= 'h100000;
		
		state <= 'd2;
	end
	
	'd2:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		
		if(idle == 0)
		begin
			state <= 'd3;
			idle <= wr_time;
		end
		else
		begin
			state <= 'd2;
			idle <= idle -'d1;
		end
	end
	'd3:
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		state <= 'd4;
	end
	//unlock _2
	'd4:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		addr <= 'h100000;
		
		state <= 'd5;
	end
	'd5:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		
		if(idle == 0)
		begin
			state <= 'd6;
			idle <= wr_time;
		end
		else
		begin
			state <= 'd5;
			idle <= idle -'d1;
		end
	end
	//unlock end ,start read reg;
	'd6:
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		state <= 'd7;
	end
	'd7:
	begin
		ce <= 'b0;
		oe <= 'b1;
		we <= 'b0;
		addr <= 'h100000;
		state <= 'd8;
	end
	'd8:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		
		if(idle == 0)
		begin
			state <= 'd9;
			idle <= rd_time;
		end
		else
		begin
			state <= 'd8;
			idle <= idle -'d1;
		end
	end
	//read reg commend end,next read
	'd9:
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		state <= 'd10;
	end
	'd10:
	begin
		ce <= 'b0;
		oe <= 'b0;
		we <= 'b1;
		addr <= 'h100000;
		state <= 'd11;
	end
	'd11:
	begin
		ce <= 'b0;
		we <= 'b1;
		oe <= 'b0;
		
		if(idle == 0)
		begin
			state <= 'd12;
			idle <= wr_time;
			led[7:0] <= data[7:0];
		end
		else
		begin
			state <= 'd11;
			idle <= idle -'d1;
		end
	end
	//read end,start programing
	'd12:
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		state <= 'd13;
	end
	//prog_1
	'd13:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		addr <= 'h100000;
		
		state <= 'd14;
	end
	'd14:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		
		if(idle == 0)
		begin
			state <= 'd15;
			idle <= wr_time;
		end
		else
		begin
			state <= 'd14;
			idle <= idle -'d1;
		end
	end
	
	'd15:
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		state <= 'd16;
	end
	//prog_2
	'd16:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		addr <= 'h100000;
		
		state <= 'd17;
	end
	
	'd17:
	begin
		ce <= 'b0;
		we <= 'b0;
		oe <= 'b1;
		
		if(idle == 0)
		begin
			state <= 'd18;
			idle <= wr_time;
		end
		else
		begin
			state <= 'd17;
			idle <= idle -'d1;
		end
	end
	
	'd18:
	begin
		ce <= 'b1;
		oe <= 'b1;
		we <= 'b1;
		
		if(!sw)
			state <= 'd0;
		else
			state <= 'd18;
	end
	default:
		state <= state;
	endcase
	
end


endmodule
