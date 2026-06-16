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
module baud_rate #(
	parameter CLK_FREQ  = 27_000_000,
	parameter BAUD_RATE = 9600
	)(
	input logic clk,
	input logic rst,
	output logic tx_tick,
	    );

function integer clog2;
	input integer value;
	begin 
		value = value - 1;
		for (clog2 = 0; value > 0; clog2 = clog2 + 1) begin
			value = value >> 1;
		end
	end
endfunction

localparam TX_MAX_COUNT = CLK_FREQ / BAUD_RATE;
localparam TX_CNT_WIDTH = clog2(TX_MAX_COUNT);

logic [TX_CNT_WIDTH-1:0] tx_cnt;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		tx_cnt  <= 0;
		tx_tick <= 1'b0;
	end else begin
		if (tx_cnt == (TX_MAX_COUNT - 1)) begin
			tx_cnt <= 0;
			tx_tick <= 1'b1;
		end else begin
			tx_cnt <= tx_cnt + 1;
			tx_tick <= 1'b0;
		end
	end
end	

endmodule

