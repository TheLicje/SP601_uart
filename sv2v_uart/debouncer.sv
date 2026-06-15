`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:06 06/15/2026 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer #(
	parameter CLK_FREQ = 27_000_000,
	parameter DELAY_MS = 20
	)(
	input logic clk,
	input logic rst,

	input logic btn_in,
	output logic btn_out
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

localparam MAX_COUNT = (CLK_FREQ / 1000) * DELAY_MS;
localparam CNT_WIDTH = clog2(MAX_COUNT);

logic [CNT_WIDTH-1:0] counter;
logic btn_sync_0, btn_sync_1;

always_ff @(posedge clk or posedge rst) begin 
	if (rst) begin
		btn_sync_0 <= 1'b0;
		btn_sync_1 <= 1'b0;
	end else begin
		btn_sync_0 <= btn_in;
		btn_sync_1 <= btn_sync_0;
	end
end

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		btn_out <= 1'b0;
		counter <= 0;
	end else if (btn_sync_1 != btn_out) begin
		if (counter == MAX_COUNT) begin
			btn_out <= btn_sync_1;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end else begin
		counter <= 0;
	end		
end

endmodule

