module led_rx (
	clk,
	rst,
	rx_valid,
	rx_data,
	led
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire rx_valid;
	input wire [7:0] rx_data;
	output reg [3:0] led;
	reg [3:0] char_cnt;
	reg [3:0] char_cnt_nxt;
	reg [3:0] led_nxt;
	always @(posedge clk or posedge rst)
		if (rst) begin
			char_cnt <= 4'b0001;
			led <= 4'b0000;
		end
		else begin
			char_cnt <= char_cnt_nxt;
			led <= led_nxt;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		char_cnt_nxt = char_cnt;
		led_nxt = led;
		if (rx_valid)
			case (char_cnt)
				4'b0001:
					if (rx_data == 8'h6c)
						char_cnt_nxt = 4'b0010;
					else
						char_cnt_nxt = 4'b0001;
				4'b0010:
					if (rx_data == 8'h65)
						char_cnt_nxt = 4'b0100;
					else
						char_cnt_nxt = 4'b0001;
				4'b0100:
					if (rx_data == 8'h64)
						char_cnt_nxt = 4'b1000;
					else
						char_cnt_nxt = 4'b0001;
				4'b1000: begin
					if (rx_data == 8'h30)
						led_nxt = 4'b0001;
					else if (rx_data == 8'h31)
						led_nxt = 4'b0010;
					else if (rx_data == 8'h32)
						led_nxt = 4'b0100;
					else if (rx_data == 8'h33)
						led_nxt = 4'b1000;
					char_cnt_nxt = 4'b0001;
				end
				default: char_cnt_nxt = 4'b0001;
			endcase
	end
	initial _sv2v_0 = 0;
endmodule
