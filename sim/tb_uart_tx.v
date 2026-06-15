`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:29:59 06/14/2026
// Design Name:   uart_tx
// Module Name:   /home/ise/Documents/SP601_uart/tb_uart_tx.v
// Project Name:  SP601_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_tx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_uart_tx;

	//	INPUTS
	reg clk, rst;
	reg baud_tick;
	reg tx_start;
	reg [7:0] tx_data;
	
	// Outputs
	wire tx_pin, tx_ready;

	// Instantiate the Unit Under Test (UUT)
	uart_tx uut (
		.clk(clk),
		.rst(rst),
		.baud_tick(baud_tick),
		.tx_start(tx_start),
		.tx_data(tx_data),
		.tx_pin(tx_pin),
		.tx_ready(tx_ready)
	);

	always #18.5 clk = ~clk;
	
	always begin
		repeat(233) @(posedge clk);
		baud_tick = 1;
		@(posedge clk);
		baud_tick = 0;
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		baud_tick = 0;
		tx_start = 0;
		tx_data = 8'b0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		@(posedge clk);
		tx_data = 8'h41;
		tx_start = 1;
		
		@(posedge clk);
		tx_start = 0;
		
		@(posedge tx_ready);
		
		#5000
		
		$stop;
	end
      
endmodule

