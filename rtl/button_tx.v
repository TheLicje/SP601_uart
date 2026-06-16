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
module button_tx (
	clk,
	rst,
	tx_ready,
	btn,
	tx_start,
	tx_data
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire tx_ready;
	input wire [3:0] btn;
	output reg tx_start;
	output reg [7:0] tx_data;
	reg [1:0] state;
	reg [1:0] state_nxt;
	reg tx_start_nxt;
	reg [7:0] tx_data_nxt;
	reg [1:0] cnt;
	reg [1:0] cnt_nxt;
	reg [3:0] btn_buf;
	reg [3:0] btn_buf_nxt;
	reg [3:0] btn_prev;
	always @(posedge clk or posedge rst)
		if (rst) begin
			tx_start <= 1'b0;
			tx_data <= 8'b00000000;
			state <= 2'd0;
			cnt <= 2'b00;
			btn_buf <= 4'b0000;
			btn_prev <= 4'b0000;
		end
		else begin
			tx_start <= tx_start_nxt;
			tx_data <= tx_data_nxt;
			state <= state_nxt;
			cnt <= cnt_nxt;
			btn_buf <= btn_buf_nxt;
			btn_prev <= btn;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		tx_start_nxt = 1'b0;
		tx_data_nxt = tx_data;
		state_nxt = state;
		cnt_nxt = cnt;
		btn_buf_nxt = btn_buf;
		case (state)
			2'd0:
				if ((btn > 0) && (btn_prev == 0)) begin
					state_nxt = 2'd1;
					btn_buf_nxt = btn;
					cnt_nxt = 2'b00;
				end
			2'd1: begin
				tx_start_nxt = 1'b1;
				if (cnt == 0)
					tx_data_nxt = 8'h62;
				else if (cnt == 1)
					tx_data_nxt = 8'h74;
				else if (cnt == 2)
					tx_data_nxt = 8'h6e;
				else if (cnt == 3) begin
					if (btn_buf[0])
						tx_data_nxt = 8'h30;
					else if (btn_buf[1])
						tx_data_nxt = 8'h31;
					else if (btn_buf[2])
						tx_data_nxt = 8'h32;
					else if (btn_buf[3])
						tx_data_nxt = 8'h33;
				end
				state_nxt = 2'd2;
			end
			2'd2:
				if (tx_ready == 1'b1) begin
					if (cnt == 3) begin
						cnt_nxt = 2'b00;
						state_nxt = 2'd0;
					end
					else begin
						cnt_nxt = cnt + 1;
						state_nxt = 2'd1;
					end
				end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule

