module uart_rx (
	clk,
	rst,
	rx_pin,
	rx_valid,
	rx_data
);
	reg _sv2v_0;
	parameter CLK_FREQ = 27000000;
	parameter BAUD_RATE = 9600;
	input wire clk;
	input wire rst;
	input wire rx_pin;
	output reg rx_valid;
	output reg [7:0] rx_data;
	function integer clog2;
		input integer value;
		begin
			value = value - 1;
			for (clog2 = 0; value > 0; clog2 = clog2 + 1)
				value = value >> 1;
		end
	endfunction
	localparam MAX_COUNT = CLK_FREQ / BAUD_RATE;
	localparam CNT_WIDTH = clog2(MAX_COUNT);
	reg [1:0] state;
	reg [1:0] state_nxt;
	reg rx_sync_0;
	reg rx_sync_1;
	reg rx_sync_2;
	reg rx_valid_nxt;
	reg [2:0] bit_cnt;
	reg [2:0] bit_cnt_nxt;
	reg [7:0] rx_data_nxt;
	reg [7:0] shift_reg;
	reg [7:0] shift_reg_nxt;
	reg [CNT_WIDTH - 1:0] cnt;
	reg [CNT_WIDTH - 1:0] cnt_nxt;
	always @(posedge clk or posedge rst)
		if (rst) begin
			rx_sync_0 <= 1'b1;
			rx_sync_1 <= 1'b1;
			rx_sync_2 <= 1'b1;
			rx_valid <= 1'b0;
			rx_data <= 8'b00000000;
			bit_cnt <= 3'b000;
			shift_reg <= 8'b00000000;
			state <= 2'd0;
			cnt <= 0;
		end
		else begin
			rx_sync_0 <= rx_pin;
			rx_sync_1 <= rx_sync_0;
			rx_sync_2 <= rx_sync_1;
			rx_valid <= rx_valid_nxt;
			rx_data <= rx_data_nxt;
			bit_cnt <= bit_cnt_nxt;
			shift_reg <= shift_reg_nxt;
			state <= state_nxt;
			cnt <= cnt_nxt;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		rx_valid_nxt = 1'b0;
		rx_data_nxt = rx_data;
		bit_cnt_nxt = bit_cnt;
		shift_reg_nxt = shift_reg;
		state_nxt = state;
		cnt_nxt = cnt;
		case (state)
			2'd0: begin
				cnt_nxt = 0;
				if ((rx_sync_1 == 1'b0) && (rx_sync_2 == 1'b1))
					state_nxt = 2'd1;
			end
			2'd1: begin
				cnt_nxt = cnt + 1;
				if (cnt == ((MAX_COUNT - 1) / 2)) begin
					if (rx_sync_1 == 1'b0) begin
						cnt_nxt = 0;
						state_nxt = 2'd2;
					end
					else
						state_nxt = 2'd0;
				end
			end
			2'd2: begin
				cnt_nxt = cnt + 1;
				if (cnt == (MAX_COUNT - 1)) begin
					cnt_nxt = 0;
					shift_reg_nxt = {rx_sync_1, shift_reg[7:1]};
					bit_cnt_nxt = bit_cnt + 1;
					if (bit_cnt == 7) begin
						bit_cnt_nxt = 0;
						state_nxt = 2'd3;
					end
				end
			end
			2'd3: begin
				cnt_nxt = cnt + 1;
				if (cnt == (MAX_COUNT - 1)) begin
					rx_valid_nxt = 1'b1;
					rx_data_nxt = shift_reg;
					bit_cnt_nxt = 0;
					state_nxt = 2'd0;
				end
			end
			default: state_nxt = 2'd0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
