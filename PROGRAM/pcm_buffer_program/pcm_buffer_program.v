`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:52:24 05/11/2013 
// Design Name: 
// Module Name:    pcm_buffer_program 
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
module pcm_buffer_program(
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
	 reg [5:0] i;
	 
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
	 'd8:cs <= 'd9;
	 'd9:cs <= 'd10;
	 'd10:cs <= 'd11;
	 'd11:cs <= 'd12;
	 'd12:cs <= 'd13;
	 'd13:cs <= 'd14;
	 'd14:cs <= 'd15;
	 
	 'd15:if (key[0] && ~key[1])             //buffer program or bit-alterable buffer write
	     cs <= 'd38;
		  else if (key[1] && ~key[0])        //read array
		       cs <= 'd16;
		  else
		  cs <= 'd0;
		  
	 'd16:begin
	      ce <= 1'b0;
			we <= 1'b0;
			rw <= 1'b0;
	      addrp <= {15'h1111,sw};
			datar <= 16'h00ff;
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
	      addrp <= {15'h1111,sw};
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
	      cs <= 'd255;
			end
			
	 'd38:begin                    //unlock
	      ce <= 1'b0;
			we <= 1'b0;
			rw <= 1'b0;
	      addrp <= {15'h1111,sw};
			datar <= 16'h0060;
	      cs <= 'd39;
			end
	 'd39:cs <= 'd40;
	 'd40:cs <= 'd41;
	 'd41:cs <= 'd42;
	 'd42:cs <= 'd43;
	 'd43:cs <= 'd44;
	 'd44:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd45;
			end
	 'd45:cs <= 'd46;
	 'd46:cs <= 'd47;
	 'd47:begin
	      ce <= 1'b0;
			we <= 1'b0;
	      addrp <= {15'h1111,sw};
			datar <= 16'h00d0;
	      cs <= 'd48;
			end
	 'd48:cs <= 'd49;
	 'd49:cs <= 'd50;
	 'd50:cs <= 'd51;
	 'd51:cs <= 'd52;
	 'd52:cs <= 'd53;
	 'd53:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd54;
			end
	 'd54:cs <= 'd55;
	 'd55:cs <= 'd56;
	 'd56:begin                  //write
	      ce <= 1'b0;
			we <= 1'b0;
	      addrp <= {15'h1111,sw};
			//datar <= 16'h00e8;
			datar <= 16'h00ea;
	      cs <= 'd57;
			end
	 'd57:cs <= 'd58;
	 'd58:cs <= 'd59;
	 'd59:cs <= 'd60;
	 'd60:cs <= 'd61;
	 'd61:cs <= 'd62;
	 'd62:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd63;
			end
	 'd63:cs <= 'd64;
	 'd64:cs <= 'd65;
	 'd65:begin
	      ce <= 1'b0;
			we <= 1'b0;
			i <= 6'h00;
	      addrp <= {15'h1111,sw};
			datar <= 16'h001f;
	      cs <= 'd66;
			end
	 'd66:cs <= 'd67;
	 'd67:cs <= 'd68;
	 'd68:cs <= 'd69;
	 'd69:cs <= 'd70;
	 'd70:cs <= 'd71;
	 'd71:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd72;
			end
	 'd72:cs <= 'd73;
	 'd73:begin
	      if (i < 6'h20)
			begin
			i <= i + 6'h01;
			cs <= 'd74;
			end
			else
	      cs <= 'd83;
			end
	 'd74:begin
			ce <= 1'b0;
			we <= 1'b0;
	      addrp <= {15'h1111,sw + i - 8'h01};
			datar <= 16'h0000 + i - 16'h01;
	      cs <= 'd75;
			end
	 'd75:cs <= 'd76;
	 'd76:cs <= 'd77;
	 'd77:cs <= 'd78;
	 'd78:cs <= 'd79;
	 'd79:cs <= 'd80;
	 'd80:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd81;
			end
	 'd81:cs <= 'd82;
	 'd82:cs <= 'd73;
	 'd83:begin
			ce <= 1'b0;
			we <= 1'b0;
	      addrp <= {15'h1111,sw};
			datar <= 16'h00d0;
	      cs <= 'd84;
			end
	 'd84:cs <= 'd85;
	 'd85:cs <= 'd86;
	 'd86:cs <= 'd87;
	 'd87:cs <= 'd88;
	 'd88:cs <= 'd89;
	 'd89:begin
	      ce <= 1'b1;
			we <= 1'b1;
	      cs <= 'd240;
			end
	 'd240:begin                  //read status
	       ce <= 1'b0;
			 oe <= 1'b0;
			 rw <= 1'b1;
	       addrp <= {15'h1111,sw};
	       cs <= 'd241;
			 end
	 'd241:cs <= 'd242;
	 'd242:cs <= 'd243;
	 'd243:cs <= 'd244;
	 'd244:cs <= 'd245;
	 'd245:cs <= 'd246;
	 'd246:cs <= 'd247;
	 'd247:cs <= 'd248;
	 'd248:cs <= 'd249;
	 'd249:cs <= 'd250;
	 'd250:cs <= 'd251;
	 'd251:cs <= 'd252;
	 'd252:cs <= 'd253;
	 'd253:begin
	       ledr <= data[7:0];
	       cs <= 'd254;
			 end
	 'd254:begin
	       ce <= 1'b1;
			 we <= 1'b1;
	       cs <= 'd255;
			 end
	 'd255:cs <= 'd255;

	 default:cs <= 'd0;
	 endcase	 
	 end	 
	 end
	 
endmodule

