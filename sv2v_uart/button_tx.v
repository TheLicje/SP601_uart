module button_tx (
	clk,
	rst,
	tx_ready,
	button,
	tx_start,
	tx_data
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire tx_ready;
	input wire [3:0] button;
	output reg tx_start;
	output reg [7:0] tx_data;
	reg tx_start_nxt;
	reg [7:0] tx_data_nxt;
	reg [3:0] button_prev;
	always @(posedge clk or posedge rst)
		if (rst) begin
			tx_start <= 1'b0;
			tx_data <= 8'b00000000;
			button_prev <= 4'b0000;
		end
		else begin
			tx_start <= tx_start_nxt;
			tx_data <= tx_data_nxt;
			button_prev <= button;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		tx_start_nxt = 1'b0;
		tx_data_nxt = tx_data;
		if (tx_ready == 1'b1) begin
			if (button[0] && (button_prev[0] == 1'b0)) begin
				tx_start_nxt = 1'b1;
				tx_data_nxt = 8'h41;
			end
			else if (button[1] && (button_prev[1] == 1'b0)) begin
				tx_start_nxt = 1'b1;
				tx_data_nxt = 8'h42;
			end
			else if (button[2] && (button_prev[2] == 1'b0)) begin
				tx_start_nxt = 1'b1;
				tx_data_nxt = 8'h43;
			end
			else if (button[3] && (button_prev[3] == 1'b0)) begin
				tx_start_nxt = 1'b1;
				tx_data_nxt = 8'h44;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
