`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: IMEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IMEM(
    input clk,
    input[31:0] pc,
    input reset,
    output reg[31:0] inst_out
);
reg[1023:0] imem;
    always @(posedge clk) begin
        if (reset) begin
             inst_out <= 0;
             imem[((0*0)+31)-:32] = 32'h003100b3;
             imem[((32*1)+31)-:32] = 32'h402081b3;
             imem[((32*2)+31)-:32] = 32'h01310313;
             imem[((32*3)+31)-:32] = 32'h00412423;
             imem[((32*4)+31)-:32] = 32'h00812283;
        end
        else begin
            inst_out <= imem[((8*pc)+31)-:32];
        end
    end
endmodule
