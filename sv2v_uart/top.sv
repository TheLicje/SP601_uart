`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:39 06/14/2026 
// Design Name: 
// Module Name:    top 
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
module top(
	input logic clk,
	input logic rst,
	
	output logic tx_pin
    );

logic baud_tick;

baud_rate u_baud_rate (
	.clk(clk),
	.rst(rst),

	.baud_tick(baud_tick)
);

uart_tx u_uart_tx (
	.clk(clk),
	.rst(rst),
	.baud_rate(baud_rate),
	.tx_start(),
	.tx_data(),

	.tx_pin(tx_pin),
	.tx_ready()
);

endmodule

