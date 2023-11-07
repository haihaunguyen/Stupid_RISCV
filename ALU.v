`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: ALU
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

module ALU(
    input[31:0] a, b,
    input[3:0] s,
    output reg[31:0] result
);
    always @(*) begin
    case (s)
        0:  result = a + b;  //add
        1:  result = a - b;  //sub
        2:  result = a << b[4:0];  //sll
        3:  result = ($signed(a) < $signed(b))?1:0; //slt
        4:  result = (a < b) ? 1 : 0; //sltu
        5:  result = a ^ b; //xor
        6:  result = a >> b[4:0]; //srl
        7:  result = a >>> b[4:0]; //sra           
        8:  result = a | b; //or
        9:  result = a & b; //and
        10: result = (a === b)?1:0; 
        11: result = b;
    endcase
    end
endmodule
