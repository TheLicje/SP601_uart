`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:46:19 06/14/2026 
// Design Name: 
// Module Name:    baud_tick 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: Baud tick 115200 for 27MHz USER_CLOCK
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module baud_rate(
	input logic clk,
	input logic rst,
	output logic baud_tick
    );

logic [7:0] counter;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		counter <= 8'b0;
	end else begin
		if (counter == 234) begin
			counter <= 8'b0;
			baud_tick <= 1'b1;
		end else begin
			counter <= counter + 1'd1;
			baud_tick <= 1'b0;
		end
	end
end			 

endmodule

