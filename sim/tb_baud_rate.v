`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:19:59 06/14/2026
// Design Name:   baud_rate
// Module Name:   /home/ise/Documents/SP601_uart/tb_baud_rate.v
// Project Name:  SP601_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: baud_rate
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_baud_rate;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire tx_tick;

	// Instantiate the Unit Under Test (UUT)
	baud_rate uut (
		.clk(clk), 
		.rst(rst), 
		.tx_tick(tx_tick),
	);

	always #18.5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
		
		#15000;

		$stop;
	end
      
endmodule

