`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: Register_File
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


module Register_File(
    input clk, reset,
    input[2:0] rwe,
    input[31:0] Data_D, 
    input[4:0] Addr_D, Addr_A, Addr_B,
    output reg[31:0] Data_A, Data_B
    );
    reg[31:0] r[0:31];
    always @(*) begin
        if (reset == 1) begin
        r[0] <= 0;
        r[1] <= 0;
        r[2] <= 0;
        r[3] <= 20;
        r[4] <= 50;
        end else 
        begin
             //read
            Data_A <= r[Addr_A];
            Data_B <= r[Addr_B];
     
            if (rwe == 1) begin //write
                r[Addr_D] <= Data_D;
            end else
            if (rwe == 2) begin //lh
                r[Addr_D][15:0] <= Data_D[15:0];
            end else
            if (rwe == 3) begin //lb
                r[Addr_D][7:0] <= Data_D[7:0];
            end else
            if (rwe == 4) begin //lhu
                r[Addr_D][31:16] <= 0;
                r[Addr_D][15:0] <= Data_D[15:0];
            end else
            if (rwe == 5) begin //lbu
                r[Addr_D][31:8] <= 0;
                r[Addr_D][7:0] <= Data_D[7:0];
            end
        end
    end  
endmodule
