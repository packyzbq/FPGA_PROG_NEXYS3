`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:33 04/16/2013 
// Design Name: 
// Module Name:    NOR_RD_ID 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:������ȡ״̬�Ĵ��������ݣ���ȷ������Ӧ��Ϊ0x80 ��      �õ�������Ϊcmd=0x70
//	��ȡ�ɹ�����show���������ݵ���ʾ��ͨ����д֤ʵ����Ϊ0x80
//	��һ���Ĺ������潲����ϵͳ��λ��ϵͳ���Զ����뵽д����״̬����ʱ��Ҫȡ����nor�ı�����Ȼ��ſ��Խ���д������
//	��Ҫ���Ĺ�������εõ����nor��״̬���Լ����н������
//  
// Dependencies: 
//v1 failed; change 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NOR_RD_ID( clk,
						reset,
						key,
						ce,
						we,
						oe,
						addr,
						data,
						leds,
						show,
						C_STATE
    );
	 
	 //I/O pins
	 input clk;				//the clock
	 input reset;			//the reset signal
	 input key;				//the press key
	 output ce,we,oe;
	 output leds;			//show the counter of the press of key 
	 output[23:0] addr;	//the base addr 0x000000
	 inout[15:0] data;	//the DQ
	 output[7:0] show;	//the led show the result
	 output[7:0] C_STATE;
	// output[7:0] N_STATE;

	//the definition of regs
	reg ce = 'b1;
	reg we = 'b1;
	reg oe = 'b1;
	reg leds = 'b0;
	reg[23:0] addr = 'h3f0000;
	reg[15:0] cmd = 'h0070;
	reg[7:0] show = 'h00;
	reg[7:0] C_STATE = 'd9;
	//reg[7:0] N_STATE = 'd0;
	assign data = ((C_STATE > 'd4) && (C_STATE < 'd8))? cmd : 'hzz;	//�������Ҫdata��we���ߺ�һ�����ڸı���Ϊd7������Ϊd8
	//the logic starts here  
	
	//the operation
	always @(posedge clk)
		begin
			if(reset)
				begin
					ce <= 'b1;
					we <= 'b1;
					oe <= 'b1;
					leds <= 'b0;
					addr <= 'h3f0000;
					//data <= 'h0000;
					show <= 'h00;	
					C_STATE <= 'd0;
				end
			else
				begin
					case(C_STATE)
						//reset to we low
						'd0: C_STATE <= 'd1;
						'd1: C_STATE <= 'd2;
						'd2: C_STATE <= 'd3;
						'd3: C_STATE <= 'd4;
						'd4: C_STATE <= 'd5;
						//we begin to low ;begin to write the cmd
						'd5: begin
							ce <= 'b0;
							we <= 'b0;
							addr <= 'h3f0000; //�Ѿ���ʼ����
							//data <= 'h0090;
							show[7:0] <= data[7:0];
							C_STATE <= 'd6;
							end
						'd6: begin
								show[7:0] <= data[7:0];
								C_STATE <= 'd7;
								end
						'd7: begin
							ce <= 'b1;
							we <= 'b1;		//finished the cmd write
							//data <= 'h0000;	//��data�ĸ��ı�we��������һ������
							C_STATE <= 'd8;
							end
						'd8: begin
							//data <= 'h0000;
							C_STATE <= 'd9;
							end
						'd9: begin	//ready to read; ce oe enable,address ready 
							ce <= 0;
							oe <=0;
							//addr <=('h000000 || 'h000001);
							C_STATE <= 'd10;
							end
							//ce & addr hold 110ns to enable output
						'd10: C_STATE <= 'd11;
						'd11: C_STATE <= 'd12;
						'd12: C_STATE <= 'd13;
						'd13: begin				//data valid
							show[7:0] <= data[7:0];
							C_STATE <= 'd14;
							end
						'd14: begin			//hold the show data
							//show[7:0] <= data[7:0];
							ce <= 'b1;
							oe <= 'b1;
							addr <= 'h000000;
							if(key)
								begin
									C_STATE <= 'd0;
									//addr <= addr +'h000001;
								end
							else
								begin
									C_STATE <= 'd14;
								end
							end	
						default: C_STATE <= 'd0;
												
						
					endcase
				end
		end
endmodule
