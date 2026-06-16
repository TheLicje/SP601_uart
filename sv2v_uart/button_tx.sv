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
	input logic [3:0] btn,

	output logic tx_start,
	output logic [7:0] tx_data
    );

typedef enum logic [1:0] {
	IDLE,
	SEND,
	WAIT
} state_t; 

state_t state, state_nxt;
logic tx_start_nxt;
logic [7:0] tx_data_nxt;
logic [1:0] cnt, cnt_nxt;
logic [3:0] btn_buf, btn_buf_nxt;
logic [3:0] btn_prev;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		tx_start <= 1'b0;
		tx_data  <= 8'b0;
		state <= IDLE;
		cnt   <= 2'b0;
		btn_buf  <= 4'b0;
        btn_prev <= 4'b0;
	end else begin
		tx_start <= tx_start_nxt;
		tx_data  <= tx_data_nxt;
		state <= state_nxt;
		cnt   <= cnt_nxt;
		btn_buf  <= btn_buf_nxt;
        btn_prev <= btn;
	end
end

always_comb begin
	tx_start_nxt = 1'b0;
	tx_data_nxt  = tx_data;
	state_nxt = state;
	cnt_nxt   = cnt;
	btn_buf_nxt  = btn_buf;

	case (state)
		IDLE: begin
			if ((btn > 0) && (btn_prev == 0)) begin
				state_nxt = SEND;
				btn_buf_nxt = btn;
				cnt_nxt = 2'b0;
			end
		end 
		
		SEND: begin
			tx_start_nxt = 1'b1;

			if (cnt == 0) begin
				tx_data_nxt = 8'h62;
			end else if (cnt == 1) begin
				tx_data_nxt = 8'h74;
			end else if (cnt == 2) begin
				tx_data_nxt = 8'h6E;
			end else if (cnt == 3) begin				
				if (btn_buf[0])		 tx_data_nxt = 8'h30;
				else if (btn_buf[1]) tx_data_nxt = 8'h31;
				else if (btn_buf[2]) tx_data_nxt = 8'h32;
				else if (btn_buf[3]) tx_data_nxt = 8'h33;
			end
			
			state_nxt = WAIT;
		end

		WAIT:begin
			if (tx_ready == 1'b1) begin
				if (cnt == 3) begin
					cnt_nxt = 2'b0;
					state_nxt = IDLE;	
				end else begin
					cnt_nxt = cnt + 1;
					state_nxt = SEND;
				end
			end
		end
	endcase 
end

endmodule

