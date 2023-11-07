`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 11:07:59 PM
// Design Name: 
// Module Name: datapath
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


module datapath(
clk,
 pc, reset
    ); 
    input reset;
    output reg[31:0] pc = 0;
    input clk;
    wire[4:0] Addr_A, Addr_B, Addr_D;
    wire[3:0] alu_ctl;
    wire[31:0] inst_out, Data_A, Data_B, out_im, out_m0, out_m1, result_ALU, Dmem_out, out_m2, out_m3, out_m4, out_m5;
    wire imm_mux_sel, rgf_mux_sel, pc_mux, pc_jalr;
    wire[2:0] rw_rf;
    wire[1:0] Gen_im_sel, rwe_dmem;
    wire[19:0] imm_to_gen;
    
    IMEM imem(.clk(clk), .reset(reset), .pc(pc), .inst_out(inst_out));
    
    Instruction_Decode in_de(.clk(clk), .rw_rf(rw_rf), .Inst(inst_out), .rd(Addr_D), .rs1(Addr_A), .rs2(Addr_B), .alu_ctl(alu_ctl), .imm_mux_sel(imm_mux_sel), 
    .Gen_im_sel(Gen_im_sel), .imm_to_gen(imm_to_gen), .rgf_mux_sel(rgf_mux_sel), .rwe_dmem(rwe_dmem), .pc_mux(pc_mux),
    .branch(result_ALU[0]), .pc_to_alu(pc_to_alu), .pc_jal(pc_jal), .pc_jalr(pc_jalr));
    
    Register_File rgf(.clk(clk), .reset(reset), .rwe(rw_rf), .Data_D(out_m1), .Addr_D(Addr_D), .Addr_A(Addr_A), .Addr_B(Addr_B),
     .Data_A(Data_A), .Data_B(Data_B));
     
    Imm_Gen im_gen(.Gen_im_sel(Gen_im_sel), .in(imm_to_gen), .out(out_im));
    
    mux_2x32 m0( .a(Data_B), .b(out_im), .s(imm_mux_sel), .o(out_m0));
    
    ALU alu(.a(out_m3), .b(out_m4), .s(alu_ctl), .result(result_ALU));
    
    DMEM Dmem(.clk(clk), .reset(reset), .rwe(rwe_dmem), .Data_in(Data_B), .Addr(result_ALU), .Data_out(Dmem_out));
    
    mux_2x32 m1( .a(result_ALU), .b(Dmem_out), .s(rgf_mux_sel), .o(out_m1));
    
    mux_2x32 m2( .a(4), .b(out_im), .s(pc_mux), .o(out_m2));
    mux_2x32 m3( .a(Data_A), .b(pc), .s(pc_to_alu), .o(out_m3));
    mux_2x32 m4( .a(out_m0), .b(4), .s(pc_jal), .o(out_m4));
    mux_2x32 m5( .a(pc), .b(Data_A), .s(pc_jalr), .o(out_m5));
    always @(posedge clk) begin
        if (reset) begin
            pc <= 0;
        end else
        pc =  out_m5 + out_m2;
    end
    
endmodule
