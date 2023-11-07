`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 05:25:22 PM
// Design Name: 
// Module Name: Instruction_Decode
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


module Instruction_Decode(
    input clk, branch,
    input[31:0] Inst,
    output reg[4:0] rd, rs1, rs2,
    output reg[3:0] alu_ctl,
    output reg imm_mux_sel,
    output reg[1:0] Gen_im_sel,
    output reg[19:0] imm_to_gen,
    output reg[2:0] rw_rf, 
    output reg rgf_mux_sel, pc_mux, pc_to_alu, pc_jal, pc_jalr,
    output reg[1:0] rwe_dmem
    );

    always @(*) begin
        rs1 = Inst[19:15];
        rs2 = Inst[24:20];
        rd = Inst[11:7];
        pc_mux = 0;
        case (Inst[6:0])
            7'b0110011: //R-type
                begin
                     pc_jalr = 0;
                     pc_jal = 0;
                     pc_to_alu = 0;
                     pc_mux = 0;
                     imm_mux_sel = 0;
                     rw_rf = 1;
                     rgf_mux_sel = 0;
                     if (Inst[14:12] == 0 && Inst[31:25] == 0)  alu_ctl = 0; //add
                     else if (Inst[14:12] == 0 && Inst[31:25] == 32)  alu_ctl = 1; //sub
                     else if (Inst[14:12] == 3'b001 && Inst[31:25] == 0)  alu_ctl = 2; //sll
                     else if (Inst[14:12] == 3'b010 && Inst[31:25] == 0)  alu_ctl = 3; //slt
                     else if (Inst[14:12] == 3'b011 && Inst[31:25] == 0)  alu_ctl = 4; //sltu
                     else if (Inst[14:12] == 3'b100 && Inst[31:25] == 0)  alu_ctl = 5; //xor
                     else if (Inst[14:12] == 3'b101 && Inst[31:25] == 0)  alu_ctl = 6; //srl
                     else if (Inst[14:12] == 3'b101 && Inst[31:25] == 32)  alu_ctl = 7; //sra
                     else if (Inst[14:12] == 3'b110 && Inst[31:25] == 0)  alu_ctl = 8; //or
                     else if (Inst[14:12] == 3'b111 && Inst[31:25] == 0)  alu_ctl = 9; //and
                  
                    Gen_im_sel = 0;
                    imm_to_gen = 0;                 
                    rwe_dmem = 0;
                     
                end
            7'b0010011: //I-type
                begin
                     pc_jalr = 0;
                     pc_jal = 0;
                     pc_to_alu = 0;
                     pc_mux = 0;
                     imm_mux_sel = 1;
                     rw_rf = 1;
                     rgf_mux_sel = 0;
                     Gen_im_sel = 0; //signed 12b
                     imm_to_gen[11:0] = Inst[31:20];
                     if (Inst[14:12] == 0 && Inst[31:25] == 0) alu_ctl = 0; //add
                     else if (Inst[14:12] == 3'b001 && Inst[31:25] == 0)  alu_ctl = 2; //sll
                     else if (Inst[14:12] == 3'b010 && Inst[31:25] == 0)  alu_ctl = 3; //slt
                     else if (Inst[14:12] == 3'b011 && Inst[31:25] == 0)  alu_ctl = 4; //sltu
                     else if (Inst[14:12] == 3'b100 && Inst[31:25] == 0)  alu_ctl = 5; //xor
                     else if (Inst[14:12] == 3'b101 && Inst[31:25] == 0)  alu_ctl = 6; //srl
                     else if (Inst[14:12] == 3'b101 && Inst[31:25] == 32)  alu_ctl = 7; //sra
                     else if (Inst[14:12] == 3'b110 && Inst[31:25] == 0)  alu_ctl = 8; //or
                     else if (Inst[14:12] == 3'b111 && Inst[31:25] == 0)  alu_ctl = 9; //and                                
                    rwe_dmem = 0;
                end
            7'b0100011: //store
                begin
                    pc_jalr = 0;
                    pc_jal = 0;
                    pc_to_alu = 0;
                    pc_mux = 0;
                    imm_mux_sel = 1;
                    Gen_im_sel = 0; //signed 12b
                    imm_to_gen[11:0] = {Inst[31:25],Inst[11:7]};
                    alu_ctl = 0;
                    if (Inst[14:12] == 2) rwe_dmem = 1; //sw
                    else if (Inst[14:12] == 1) rwe_dmem = 2; //sh
                    else if (Inst[14:12] == 0) rwe_dmem = 3; //sb                  
                    rw_rf = 0;
                    rgf_mux_sel = 0;                
                end
            7'b0000011: //load
                begin
                    pc_jalr = 0;
                    pc_jal = 0;
                    pc_to_alu = 0;
                    pc_mux = 0;
                    imm_mux_sel = 1;
                    Gen_im_sel = 0; //signed 12b
                    imm_to_gen[11:0] = Inst[31:20];
                    alu_ctl = 0;
                    rwe_dmem = 0;
                    rgf_mux_sel = 1;
                    if (Inst[14:12] == 0) rw_rf = 3; //lb
                    else if (Inst[14:12] == 1) rw_rf = 2; //lh
                    else if (Inst[14:12] == 2) rw_rf = 1; //lw
                    else if (Inst[14:12] == 4) rw_rf = 5; //lbu
                    else if (Inst[14:12] == 5) rw_rf = 4; //lhu                                               
                    rwe_dmem = 0;
                end
            7'b1100011: //B-type
                begin
                    pc_jalr = 0;
                    pc_jal = 0;
                    pc_to_alu = 0;
                    imm_mux_sel = 0;
                    Gen_im_sel = 1; //13bit im 
                    imm_to_gen[11:0] = {Inst[31], Inst[7], Inst[30:25], Inst[11:8]};
                    if (Inst[14:12] == 0) begin //beq
                            alu_ctl = 10;
                            pc_mux = branch;
                        end
                    if (Inst[14:12] == 1) begin //bne
                            alu_ctl = 10;
                            pc_mux = !branch;
                        end else
                        
                    if (Inst[14:12] == 4) begin //blt
                            alu_ctl = 3;
                            pc_mux = branch;
                        end else
                    if (Inst[14:12] == 5) begin //bge
                            alu_ctl = 4;
                            pc_mux = !branch;
                        end else
                    if (Inst[14:12] == 6) begin //bltu
                            alu_ctl = 4;
                            pc_mux = branch;
                        end else
                    if (Inst[14:12] == 7) begin //bgeu
                            alu_ctl = 4;
                            pc_mux = !branch;
                        end
                    rw_rf = 0;
                    rgf_mux_sel = 0;     
                    rwe_dmem = 0;
                end
            7'b0001111: //Fence Fence.I 
                begin
                    
                end
            7'b1110011: //ecall ebreak
                begin

                end
            7'b0110111: //LUI
                begin
                    pc_jalr = 0;
                    pc_jal = 0;
                    pc_to_alu = 0;
                    imm_mux_sel = 1;
                    Gen_im_sel = 2; //signed 20b
                    imm_to_gen =  Inst[31:12];
                    pc_mux = 0;
                    rw_rf = 1;
                    rgf_mux_sel = 0;
                    alu_ctl = 11;           
                    rwe_dmem = 0;
                end
            7'b0010111: //AUIPC
                begin
                    pc_jalr = 0;
                    pc_jal = 0;
                    pc_to_alu = 1;
                    imm_mux_sel = 1;
                    Gen_im_sel = 2; //signed 20b
                    imm_to_gen =  Inst[31:12];
                    pc_mux = 0;
                    rw_rf = 1;
                    rgf_mux_sel = 0;
                    alu_ctl = 0;          
                    rwe_dmem = 0;
                    
                end
            7'b1101111: //JAL
                begin
                    pc_jalr = 0;
                    pc_mux = 1;
                    pc_jal = 1;
                    pc_to_alu = 1;
                    alu_ctl = 0;
                    imm_mux_sel = 1;
                    rw_rf = 1;
                    rgf_mux_sel = 0;
                    Gen_im_sel = 3; //signed 20b jal
                    imm_to_gen =  {Inst[31],Inst[19:12], Inst[20], Inst[30:21]};
                    rwe_dmem = 0;
                               
                end
            7'b1100111: //JALR
                begin
                    pc_jalr = 1;
                    imm_mux_sel = 1;
                    Gen_im_sel = 0; //signed 12b 
                    imm_to_gen[11:0] = Inst[31:20];                  
                    pc_mux = 1;
                    pc_jal = 1;
                    pc_to_alu = 1;
                    alu_ctl = 0; 
                    rw_rf = 1;
                    rgf_mux_sel = 0;      
                    rwe_dmem = 0;

                end
        endcase

    end
endmodule
