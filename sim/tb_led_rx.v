`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:30:44 06/17/2026
// Design Name:   led_rx
// Module Name:   /home/ise/Documents/SP601_uart/sim/tb_led_rx.v
// Project Name:  SP601_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: led_rx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_led_rx;

	// Inputs
	reg clk;
	reg rst;
	reg rx_valid;
	reg [7:0] rx_data;

	// Outputs
	wire [3:0] led;
	
	reg [31:0] string;
	
	// Instantiate the Unit Under Test (UUT)
	led_rx uut (
		.clk(clk), 
		.rst(rst), 
		.rx_valid(rx_valid), 
		.rx_data(rx_data), 
		.led(led)
	);
	
	always #18.5 clk = ~clk;
	
	task send_cmd;
		input [31:0] cmd;
		integer i;
		begin
			for (i = 3; i >= 0; i = i - 1) begin
				rx_valid = 1;
				rx_data = cmd[i*8 +: 8];
				repeat(1)@(posedge clk);
				rx_valid = 0;
				repeat(100)@(posedge clk);
			end
			rx_data = 0;
			repeat(200)@(posedge clk);
		end
	endtask

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		rx_valid = 0;
		rx_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		send_cmd("led0");
		send_cmd("led1");
		send_cmd("led2");
		send_cmd("led3");
		send_cmd("lede3");
		
		repeat(1000)@(posedge clk);
		$stop;
	end
      
endmodule

