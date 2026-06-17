`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:25:27 06/15/2026
// Design Name:   button_tx
// Module Name:   /home/ise/Documents/SP601_uart/tb_button_tx.v
// Project Name:  SP601_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: button_tx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_button_tx;

	// Inputs
	reg clk;
	reg rst;
	reg tx_ready;
	reg [3:0] button;

	// Outputs
	wire tx_start;
	wire [7:0] tx_data;
	
	// Varaibles
	integer i, j;

	// Instantiate the Unit Under Test (UUT)
	button_tx uut (
		.clk(clk), 
		.rst(rst), 
		.tx_ready(tx_ready), 
		.btn(button), 
		.tx_start(tx_start), 
		.tx_data(tx_data)
	);
	
	always #18.5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		tx_ready = 1;
		button = 4'b0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		
		// Add stimulus here
		for (i = 0; i < 4; i = i + 1) begin
			button[i] = 1;
			@(posedge clk);
			@(posedge clk);
			button[i] = 0;
			
			for (j = 0; j < 6; j = j + 1) begin
				@(posedge tx_start);
				tx_ready = 0;
				repeat(10) @(posedge clk);
				tx_ready = 1;
			end
			
			repeat(50) @(posedge clk);
		end
		
		$stop;
	end
      
endmodule

