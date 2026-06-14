`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:46:19 06/14/2026 
// Design Name: 
// Module Name:    baud_rate 
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
module baud_rate (
        clk,
        rst,
        baud_tick
);
        input wire clk;
        input wire rst;
        output reg baud_tick;
        reg [7:0] counter;
        always @(posedge clk or posedge rst)
                if (rst)
                        counter <= 8'b00000000;
                else if (counter == 234) begin
                        counter <= 8'b00000000;
                        baud_tick <= 1'b1;
                end
                else begin
                        counter <= counter + 1'd1;
                        baud_tick <= 1'b0;
                end
endmodule
