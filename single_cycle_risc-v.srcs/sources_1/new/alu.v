`timescale 1ns / 1ps
module alu(input  wire [31:0] a, b,
           input  wire [2:0]  alucontrol,
           output reg  [31:0] result,
           output wire        zero);

    always @(*)
        case (alucontrol)
            3'b000: result = a + b;        // add
            3'b001: result = a - b;        // subtract
            3'b010: result = a & b;        // and
            3'b011: result = a | b;        // or
            3'b101: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // slt
            default: result = 32'bx;
        endcase

    assign zero = (result == 32'b0);
endmodule
