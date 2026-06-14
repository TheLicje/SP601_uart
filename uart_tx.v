`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:41:27 06/14/2026 
// Design Name: 
// Module Name:    uart_tx 
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
module uart_tx (
	clk,
	rst,
	baud_tick,
	tx_start,
	tx_data,
	tx_pin,
	tx_ready
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire baud_tick;
	input wire tx_start;
	input wire [7:0] tx_data;
	output reg tx_pin;
	output reg tx_ready;
	reg [1:0] state;
	reg [1:0] state_nxt;
	reg [2:0] cnt;
	reg [2:0] cnt_nxt;
	reg [7:0] shift_reg;
	reg [7:0] shift_reg_nxt;
	always @(posedge clk or posedge rst)
		if (rst) begin
			state <= 2'd0;
			cnt <= 3'b000;
			shift_reg <= 8'b00000000;
		end
		else begin
			state <= state_nxt;
			cnt <= cnt_nxt;
			shift_reg <= shift_reg_nxt;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		state_nxt = state;
		cnt_nxt = cnt;
		shift_reg_nxt = shift_reg;
		tx_pin = 1'b1;
		tx_ready = 1'b0;
		case (state)
			2'd0: begin
				tx_ready = 1'b1;
				if (tx_start) begin
					state_nxt = 2'd1;
					shift_reg_nxt = tx_data;
				end
			end
			2'd1: begin
				tx_pin = 1'b0;
				if (baud_tick) begin
					state_nxt = 2'd2;
					cnt_nxt = 3'b000;
				end
			end
			2'd2: begin
				tx_pin = shift_reg[0];
				if (baud_tick) begin
					shift_reg_nxt = {1'b0, shift_reg[7:1]};
					if (cnt == 3'd7)
						state_nxt = 2'd3;
					else
						cnt_nxt = cnt + 3'd1;
				end
			end
			2'd3: begin
				tx_pin = 1'b1;
				if (baud_tick)
					state_nxt = 2'd0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule

