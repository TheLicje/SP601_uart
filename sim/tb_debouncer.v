`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:51:48 06/15/2026
// Design Name:   debouncer
// Module Name:   /home/ise/Documents/SP601_uart/sim/tb_debouncer.v
// Project Name:  SP601_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: debouncer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_debouncer;

	// Inputs
	reg clk;
	reg rst;
	reg btn_in;

	// Outputs
	wire btn_out;

	// Instantiate the Unit Under Test (UUT)
	debouncer uut (
		.clk(clk), 
		.rst(rst), 
		.btn_in(btn_in), 
		.btn_out(btn_out)
	);

	always #18.5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		btn_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		repeat(10) begin
			#1000 btn_in = 1;
			#1000 btn_in = 0;
		end
		
		#1000 btn_in = 1;
		#25_000_000;
		
		$stop;
	end
      
endmodule

