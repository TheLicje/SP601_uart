`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:31 06/16/2026 
// Design Name: 
// Module Name:    uart_rx 
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
module uart_rx #(
	parameter CLK_FREQ  = 27_000_000,
	parameter BAUD_RATE = 9600
)(
	input logic clk,
	input logic rst,
	
	input logic rx_pin,
	output logic rx_valid,
	output logic [7:0] rx_data    
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

localparam MAX_COUNT = CLK_FREQ / BAUD_RATE;
localparam CNT_WIDTH = clog2(MAX_COUNT);

typedef enum logic [1:0] {
	IDLE,
	START_BIT,
	DATA_BITS,
	STOP_BIT
} state_t;

state_t state, state_nxt;
logic rx_sync_0, rx_sync_1, rx_sync_2;
logic rx_valid_nxt;
logic [2:0] bit_cnt, bit_cnt_nxt;
logic [7:0] rx_data_nxt;
logic [7:0] shift_reg, shift_reg_nxt;
logic [CNT_WIDTH-1:0] cnt, cnt_nxt;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin 
		rx_sync_0   <= 1'b1;
		rx_sync_1   <= 1'b1;
		rx_sync_2   <= 1'b1;

		rx_valid    <= 1'b0;	
		rx_data     <= 8'b0;
		bit_cnt		<= 3'b0;
		shift_reg   <= 8'b0;
		state 		<= IDLE;
		cnt   		<= 0;
	end else begin
		rx_sync_0   <= rx_pin;
        rx_sync_1   <= rx_sync_0;
        rx_sync_2   <= rx_sync_1;

		rx_valid    <= rx_valid_nxt;
		rx_data     <= rx_data_nxt;
		bit_cnt     <= bit_cnt_nxt;
		shift_reg   <= shift_reg_nxt;	
		state 		<= state_nxt;
		cnt   		<= cnt_nxt;
	end
end

always_comb begin
	rx_valid_nxt  = 1'b0;
	rx_data_nxt   = rx_data;
	bit_cnt_nxt   = bit_cnt;
	shift_reg_nxt = shift_reg;	
	state_nxt     = state;
	cnt_nxt       = cnt;
	
	case (state)
		IDLE: begin
			cnt_nxt = 0;
			if ((rx_sync_1 == 1'b0) && (rx_sync_2 == 1'b1)) begin
				state_nxt = START_BIT;
			end 
		end 

		START_BIT: begin
			cnt_nxt = cnt + 1;
			if ((cnt == (MAX_COUNT - 1) / 2)) begin
				if (rx_sync_1 == 1'b0) begin
					cnt_nxt = 0;
					state_nxt = DATA_BITS;
				end else begin
					state_nxt = IDLE;
				end
			end
		end

		DATA_BITS: begin
			cnt_nxt = cnt + 1;
			if (cnt == (MAX_COUNT - 1)) begin
				cnt_nxt = 0;
				shift_reg_nxt = {rx_sync_1, shift_reg[7:1]};
				bit_cnt_nxt = bit_cnt + 1;
				if (bit_cnt == 7) begin
					bit_cnt_nxt = 0;
					state_nxt = STOP_BIT;
				end
			end
		end

		STOP_BIT: begin
			cnt_nxt = cnt + 1;
			if (cnt == (MAX_COUNT - 1)) begin
				rx_valid_nxt = 1'b1;
				rx_data_nxt = shift_reg;
				bit_cnt_nxt = 0;
				state_nxt = IDLE;
			end
		end
		
		default: state_nxt = IDLE;
	endcase
end

endmodule
