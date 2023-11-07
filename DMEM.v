`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk, reset, 
    input[1:0] rwe,
    input[31:0] Data_in,
    input[6:0] Addr,
    output reg[31:0] Data_out
    );
    reg[1023:0] dmem;
    always @(*) begin
        if (reset == 1) begin 
            dmem[175:144] <= 32'h0; 
        end
        else begin
            if (rwe == 0) begin //read
                Data_out <= dmem[((8*Addr)+31)-:32];
            end else
            if (rwe == 1) begin //SW
                dmem[((8*Addr)+31)-:32] <= Data_in;
            end else
            if (rwe == 2) begin // SH
                dmem[((8*Addr)+15)-:16] <= Data_in[15:0];
            end else
            if (rwe == 3) begin //SB
                dmem[((8*Addr)+7)-:8] <= Data_in[7:0];
            end
        end
    end
    
endmodule
