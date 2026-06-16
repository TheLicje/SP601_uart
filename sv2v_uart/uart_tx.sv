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
module uart_tx(
	input logic clk,
	input logic rst,
	input logic baud_tick,

	input  logic tx_start,
	input  logic [7:0] tx_data,
    output logic tx_pin,
	output logic tx_ready
    );

typedef enum logic [2:0] {
    IDLE,
	SYNC,
    START_BIT,
    DATA_BITS,
    STOP_BIT
} state_t;

state_t state, state_nxt;

logic [2:0] cnt, cnt_nxt;
logic [7:0] shift_reg, shift_reg_nxt;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		state <= IDLE;
		cnt <= 3'b0;
		shift_reg <= 8'b0;
	end else begin
		state <= state_nxt;
		cnt <= cnt_nxt;
		shift_reg <= shift_reg_nxt;
	end
end

always_comb begin
	state_nxt = state;
	cnt_nxt = cnt;
	shift_reg_nxt = shift_reg;

	tx_pin = 1'b1;
	tx_ready = 1'b0;

	case (state)
		IDLE: begin
			tx_ready = 1'b1;
			if (tx_start) begin
				state_nxt = SYNC;
				shift_reg_nxt = tx_data;
			end
		end

		SYNC: begin
			tx_ready = 1'b0;
			tx_pin = 1'b1;

			if (baud_tick) begin
				state_nxt = START_BIT;
			end
		end

		START_BIT: begin
			tx_pin = 1'b0;
			if (baud_tick) begin
				state_nxt = DATA_BITS;
				cnt_nxt = 3'b0;
			end
		end

		DATA_BITS: begin
			tx_pin = shift_reg[0];

			if (baud_tick) begin
				shift_reg_nxt = {1'b0, shift_reg[7:1]};

				if (cnt == 3'd7) begin
					state_nxt = STOP_BIT;
				end else begin
					cnt_nxt = cnt + 3'd1;
				end
			end 
		end

		STOP_BIT: begin
			tx_pin = 1'b1;
			if (baud_tick) begin
				state_nxt = IDLE;
			end
		end
	endcase 
end

endmodule
