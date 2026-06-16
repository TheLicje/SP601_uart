`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:57:18 06/16/2026
// Design Name:   uart_rx
// Module Name:   /home/ise/Documents/SP601_uart/sim/tb_uart_rx.v
// Project Name:  SP601_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_rx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_uart_rx;

	// Inputs
	reg clk;
	reg rst;
	reg rx_pin;

	// Outputs
	wire rx_valid;
	wire [7:0] rx_data;

	// Instantiate the Unit Under Test (UUT)
	uart_rx uut (
		.clk(clk), 
		.rst(rst), 
		.rx_pin(rx_pin), 
		.rx_valid(rx_valid), 
		.rx_data(rx_data)
	);
	
	always #18.5 clk = ~clk;

	task send_byte;
		input [7:0] data;
		integer i;
		begin
			rx_pin = 0;
			repeat(2812)@(posedge clk);
			
			for (i = 0; i < 8; i = i + 1) begin
				rx_pin = data[i];
				repeat(2812)@(posedge clk);
			end
			
			rx_pin = 1;
			repeat(2812)@(posedge clk);
		end
	endtask
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		rx_pin = 1;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		send_byte(8'h41);
		repeat(1000)@(posedge clk);
		send_byte(8'h61);
		repeat(1000)@(posedge clk);
		
		$stop;
	end
      
endmodule

