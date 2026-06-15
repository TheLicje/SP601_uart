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
	input logic [3:0] btn,
	
	output logic tx_pin
    );

logic baud_tick;
logic tx_ready;
logic btn_start;
logic [7:0] btn_data;

baud_rate u_baud_rate (
	.clk(clk),
	.rst(rst),

	.baud_tick(baud_tick)
);

button_tx u_button_tx (
	.clk(clk),
	.rst(rst),
	.tx_ready(tx_ready),
	.button(btn),
	
	.tx_start(btn_start),
	.tx_data(btn_data)
);

uart_tx u_uart_tx (
	.clk(clk),
	.rst(rst),
	.baud_tick(baud_tick),
	.tx_start(btn_start),
	.tx_data(btn_data),

	.tx_pin(tx_pin),
	.tx_ready(tx_ready)
);

endmodule

