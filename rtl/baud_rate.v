`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:46:19 06/14/2026 
// Design Name: 
// Module Name:    baud_rate 
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
module baud_rate (
	clk,
	rst,
	baud_tick
);
	parameter CLK_FREQ = 27000000;
	parameter BAUD_RATE = 9600;
	input wire clk;
	input wire rst;
	output reg baud_tick;
	function integer clog2;
		input integer value;
		begin
			value = value - 1;
			for (clog2 = 0; value > 0; clog2 = clog2 + 1)
				value = value >> 1;
		end
	endfunction
	localparam MAX_COUNT = CLK_FREQ / BAUD_RATE;
	localparam CNT_WIDTH = clog2(MAX_COUNT);
	reg [CNT_WIDTH - 1:0] counter;
	always @(posedge clk or posedge rst)
		if (rst) begin
			counter <= 0;
			baud_tick <= 1'b0;
		end
		else if (counter == (MAX_COUNT - 1)) begin
			counter <= 0;
			baud_tick <= 1'b1;
		end
		else begin
			counter <= counter + 1;
			baud_tick <= 1'b0;
		end
endmodule

