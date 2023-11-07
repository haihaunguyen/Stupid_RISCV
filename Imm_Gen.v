`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: Imm_Gen
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


module Imm_Gen(
    input[1:0] Gen_im_sel,
    input[19:0] in,
    output reg[31:0] out
    );

    always @(*) begin
        case (Gen_im_sel)
            0:
                begin
                    out = ((32'hffffffff * in[11]) << 12) | in[11:0];
                end
            1:
                begin
                    out = (((32'hffffffff * in[11]) << 12) | in[11:0]) << 1;
                end
            2:
                begin
                    out = (32'b0 | in[19:0] ) << 12;
                end
            3:
                begin
                     out = (((32'hffffffff * in[19]) << 20) | in) << 1;
                end
        endcase

    end
endmodule
