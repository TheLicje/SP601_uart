`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:06 06/15/2026 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer (
	clk,
	rst,
	btn_in,
	btn_out
);
	parameter CLK_FREQ = 27000000;
	parameter DELAY_MS = 20;
	input wire clk;
	input wire rst;
	input wire btn_in;
	output reg btn_out;
	function integer clog2;
		input integer value;
		begin
			value = value - 1;
			for (clog2 = 0; value > 0; clog2 = clog2 + 1)
				value = value >> 1;
		end
	endfunction
	localparam MAX_COUNT = (CLK_FREQ / 1000) * DELAY_MS;
	localparam CNT_WIDTH = clog2(MAX_COUNT);
	reg [CNT_WIDTH - 1:0] counter;
	reg btn_sync_0;
	reg btn_sync_1;
	always @(posedge clk or posedge rst)
		if (rst) begin
			btn_sync_0 <= 1'b0;
			btn_sync_1 <= 1'b0;
		end
		else begin
			btn_sync_0 <= btn_in;
			btn_sync_1 <= btn_sync_0;
		end
	always @(posedge clk or posedge rst)
		if (rst) begin
			btn_out <= 1'b0;
			counter <= 0;
		end
		else if (btn_sync_1 != btn_out) begin
			if (counter == MAX_COUNT) begin
				btn_out <= btn_sync_1;
				counter <= 0;
			end
			else
				counter <= counter + 1;
		end
		else
			counter <= 0;
endmodule

