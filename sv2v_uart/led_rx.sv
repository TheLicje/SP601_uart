`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:45:25 06/17/2026 
// Design Name: 
// Module Name:    led_rx 
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
module led_rx(
	input logic clk,
	input logic rst,
	
	input logic  rx_valid,
	input logic  [7:0] rx_data,
	output logic [3:0] led
    );

logic [3:0] char_cnt, char_cnt_nxt;
logic [3:0] led_nxt, led_buf, led_buf_nxt;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		char_cnt <= 4'd0;
		led      <= 4'b0;
		led_buf  <= 4'b0;
	end else begin
		char_cnt <= char_cnt_nxt;
		led		 <= led_nxt;
		led_buf  <= led_buf_nxt;
	end
end

always_comb begin
	char_cnt_nxt = char_cnt;
	led_nxt 	 = led;
	led_buf_nxt  = led_buf;

	if (rx_valid) begin
		case (char_cnt)
			4'd0: begin
				if (rx_data == 8'h6C) begin // 'l'
					char_cnt_nxt = 4'd1;
                end else begin
                	char_cnt_nxt = 4'd0;
				end			
			end 
	
			4'd1: begin
				if (rx_data == 8'h65) begin // 'e'
                    char_cnt_nxt = 4'd2;
                end else begin
                    char_cnt_nxt = 4'd0;
                end
			end
	
			4'd2: begin
				if (rx_data == 8'h64) begin // 'd'
                    char_cnt_nxt = 4'd3;
                end else begin
                    char_cnt_nxt = 4'd0;
                end			
			end
			
			4'd3: begin
				if (rx_data == 8'h30)      led_buf_nxt = 4'b0001; // '0'
				else if (rx_data == 8'h31) led_buf_nxt = 4'b0010; // '1'
				else if (rx_data == 8'h32) led_buf_nxt = 4'b0100; // '2'
				else if (rx_data == 8'h33) led_buf_nxt = 4'b1000; // '3'
				else char_cnt_nxt = 4'd0;

				char_cnt_nxt = 4'd4;
			end

			4'd4: begin
				if (rx_data == 8'h0D || rx_data == 8'h0A) begin
					led_nxt = led ^ led_buf;
				end
				led_buf_nxt = 4'b0;	
				char_cnt_nxt = 4'd0;				
			end

			default: char_cnt_nxt = 4'd0;
		endcase 
	end
end

endmodule

