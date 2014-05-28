`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:19:51 04/25/2013
// Design Name:   UNLOCK_RDID_ERASE_RDSTATUSREG
// Module Name:   E:/FPGA_stu/xilinx/NOR/UNLOCK_RDID_ERASE_RDSTATUSREG/SM_ERASE.v
// Project Name:  UNLOCK_RDID_ERASE_RDSTATUSREG
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UNLOCK_RDID_ERASE_RDSTATUSREG
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SM_ERASE;

	// Inputs
	reg CLK;
	reg RESET;

	// Outputs
	wire CE;
	wire WE;
	wire OE;
	wire [23:0] ADDR;
	wire [7:0] SHOW;

	// Bidirs
	wire [15:0] DATA;

	// Instantiate the Unit Under Test (UUT)
	UNLOCK_RDID_ERASE_RDSTATUSREG uut (
		.CLK(CLK), 
		.RESET(RESET), 
		.CE(CE), 
		.WE(WE), 
		.OE(OE), 
		.ADDR(ADDR), 
		.SHOW(SHOW), 
		.DATA(DATA)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		RESET = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever begin
		#15
		CLK <= ~CLK;
		end

	end
      
endmodule

