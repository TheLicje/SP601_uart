`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:28:30 06/14/2026 
// Design Name: 
// Module Name:    button_tx 
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
module button_tx(
	input logic clk,
	input logic rst,
	input logic tx_ready,
	input logic [3:0] button,

	output logic tx_start,
	output logic [7:0] tx_data
    );

logic tx_start_nxt;
logic [7:0] tx_data_nxt;
logic [3:0] button_prev;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		tx_start <= 1'b0;
		tx_data  <= 8'b0;
		button_prev <= 4'b0;
	end else begin 
		tx_start <= tx_start_nxt;
		tx_data  <= tx_data_nxt;
		button_prev <= button;
	end
end

always_comb begin
	tx_start_nxt = 1'b0;
	tx_data_nxt  = tx_data;

	if (tx_ready == 1'b1) begin 
		if (button[0] && button_prev[0] == 1'b0) begin
			tx_start_nxt = 1'b1;
			tx_data_nxt = 8'h41; // 'A'
		end else if (button[1] && button_prev[1] == 1'b0)begin
			tx_start_nxt = 1'b1;
			tx_data_nxt = 8'h42; // 'B'
		end else if (button[2] && button_prev[2] == 1'b0)begin
			tx_start_nxt = 1'b1;
			tx_data_nxt = 8'h43; // 'C'
		end else if (button[3] && button_prev[3] == 1'b0)begin
			tx_start_nxt = 1'b1;
			tx_data_nxt = 8'h44; // 'D'
		end
	end
end

endmodule

