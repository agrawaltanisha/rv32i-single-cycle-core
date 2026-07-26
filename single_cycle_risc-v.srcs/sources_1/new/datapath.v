`timescale 1ns / 1ps
module datapath(
                input  wire        clk, reset,
                input  wire [1:0]  ResultSrc,
                input  wire        PCSrc, ALUSrc,
                input  wire        RegWrite,
                input  wire [1:0]  ImmSrc,
                input  wire [2:0]  ALUControl,
                input  wire [31:0] Instr,
                input  wire [31:0] ReadData,
                output wire        Zero,
                output wire [31:0] PC,
                output wire [31:0] ALUResult, WriteData );
                
wire [31:0] PCNext, PCPlus4, PCTarget;
 wire [31:0] ImmExt;
// next PC logic
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder       pcadd4(PC, 32'd4, PCPlus4);
    adder       pcaddbranch(PC, ImmExt, PCTarget);
    mux2  #(32) pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
    
 wire [31:0] Result;
 wire [31:0] SrcA, SrcB;
 
 // register file logic
    regfile     rf(clk, RegWrite, Instr[19:15], Instr[24:20],
                   Instr[11:7], Result, SrcA, WriteData);
    extend      ext(Instr[31:7], ImmSrc, ImmExt);

// ALU logic
    mux2  #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu         alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux3  #(32) resultmux(ALUResult, ReadData, PCPlus4,
                          ResultSrc, Result);
endmodule

    
    