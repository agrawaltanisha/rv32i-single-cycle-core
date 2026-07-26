`timescale 1ns / 1ps
module riscvsingle(input  wire        clk, reset,
                   output wire [31:0] PC,
                   input  wire [31:0] Instr,
                   output wire        MemWrite,
                   output wire [31:0] ALUResult, WriteData,
                   input  wire [31:0] ReadData);

    wire       ALUSrc, RegWrite, Jump, Zero, PCSrc;
    wire [1:0] ResultSrc, ImmSrc;
    wire [2:0] ALUControl;

    controller c(Instr[6:0], Instr[14:12], Instr[30], Zero,
                 ResultSrc, MemWrite, PCSrc,
                 ALUSrc, RegWrite, Jump,
                 ImmSrc, ALUControl);
    datapath dp(clk, reset, ResultSrc, PCSrc,
                ALUSrc, RegWrite,
                ImmSrc, ALUControl,
                Instr, ReadData, Zero, PC, ALUResult, WriteData);
endmodule
