module top (
	clk,
	rst,
	btn,
	tx_pin
);
	input wire clk;
	input wire rst;
	input wire [3:0] btn;
	output wire tx_pin;
	wire baud_tick;
	wire tx_ready;
	wire btn_start;
	wire [7:0] btn_data;
	baud_rate u_baud_rate(
		.clk(clk),
		.rst(rst),
		.baud_tick(baud_tick)
	);
	button_tx u_button_tx(
		.clk(clk),
		.rst(rst),
		.tx_ready(tx_ready),
		.button(btn),
		.tx_start(btn_start),
		.tx_data(btn_data)
	);
	uart_tx u_uart_tx(
		.clk(clk),
		.rst(rst),
		.baud_tick(baud_tick),
		.tx_start(btn_start),
		.tx_data(btn_data),
		.tx_pin(tx_pin),
		.tx_ready(tx_ready)
	);
endmodule
