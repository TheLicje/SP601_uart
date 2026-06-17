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
logic [3:0] led_nxt;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		char_cnt <= 4'b0001;
		led      <= 4'b0000;
	end else begin
		char_cnt <= char_cnt_nxt;
		led		 <= led_nxt;
	end
end

always_comb begin
	char_cnt_nxt = char_cnt;
	led_nxt 	 = led;

	if (rx_valid) begin
		case (char_cnt)
			4'b0001: begin
				if (rx_data == 8'h6C) begin
					char_cnt_nxt = 4'b0010;
                end else begin
                	char_cnt_nxt = 4'b0001;
				end			
			end 
	
			4'b0010: begin
				if (rx_data == 8'h65) begin
                    char_cnt_nxt = 4'b0100;
                end else begin
                    char_cnt_nxt = 4'b0001;
                end
			end
	
			4'b0100: begin
				if (rx_data == 8'h64) begin
                    char_cnt_nxt = 4'b1000;
                end else begin
                    char_cnt_nxt = 4'b0001;
                end			
			end
			
			4'b1000: begin
				if (rx_data == 8'h30)      led_nxt = 4'b0001;
				else if (rx_data == 8'h31) led_nxt = 4'b0010;
				else if (rx_data == 8'h32) led_nxt = 4'b0100;
				else if (rx_data == 8'h33) led_nxt = 4'b1000;

				char_cnt_nxt = 4'b0001;
			end

			default: char_cnt_nxt = 4'b0001;
		endcase 
	end
end

endmodule

