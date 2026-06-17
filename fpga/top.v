`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:39 06/14/2026 
// Design Name: 
// Module Name:    top 
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
module top (
	clk,
	rst,
	btn,
	rx_pin,
	led,
	tx_pin
);
	input wire clk;
	input wire rst;
	input wire [3:0] btn;
	input wire rx_pin;
	output wire [3:0] led;
	output wire tx_pin;
	localparam CLK_FREQ = 27000000;
	localparam BAUD_RATE = 9600;
	wire tx_tick;
	wire tx_ready;
	wire rx_valid;
	wire [7:0] rx_data;
	wire btn_start;
	wire [7:0] btn_data;
	wire [3:0] btn_debounce;
	baud_rate #(
		.CLK_FREQ(CLK_FREQ),
		.BAUD_RATE(BAUD_RATE)
	) u_baud_rate(
		.clk(clk),
		.rst(rst),
		.tx_tick(tx_tick)
	);
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < 4; _gv_i_1 = _gv_i_1 + 1) begin : gen_debouncers
			localparam i = _gv_i_1;
			debouncer #(
				.CLK_FREQ(CLK_FREQ),
				.DELAY_MS(20)
			) u_debouncer(
				.clk(clk),
				.rst(rst),
				.btn_in(btn[i]),
				.btn_out(btn_debounce[i])
			);
		end
	endgenerate
	button_tx u_button_tx(
		.clk(clk),
		.rst(rst),
		.tx_ready(tx_ready),
		.btn(btn_debounce),
		.tx_start(btn_start),
		.tx_data(btn_data)
	);
	uart_tx u_uart_tx(
		.clk(clk),
		.rst(rst),
		.baud_tick(tx_tick),
		.tx_start(btn_start),
		.tx_data(btn_data),
		.tx_pin(tx_pin),
		.tx_ready(tx_ready)
	);
	uart_rx #(
		.CLK_FREQ(CLK_FREQ),
		.BAUD_RATE(BAUD_RATE)
	) u_uart_rx(
		.clk(clk),
		.rst(rst),
		.rx_pin(rx_pin),
		.rx_valid(rx_valid),
		.rx_data(rx_data)
	);
	led_rx u_led_rx(
		.clk(clk),
		.rst(rst),
		.rx_valid(rx_valid),
		.rx_data(rx_data),
		.led(led)
	);
endmodule
