`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 11:10:15 PM
// Design Name: 
// Module Name: mux_2x32
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


module mux_2x32(
    input[31:0] a, b,   
    input s ,
    output reg[31:0] o   
    );
    
    always @(*) begin
         o = (s == 0) ? a : b; 
    end
endmodule
