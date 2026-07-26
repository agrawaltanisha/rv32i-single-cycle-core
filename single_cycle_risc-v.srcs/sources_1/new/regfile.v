`timescale 1ns / 1ps
module regfile(input  wire        clk,
               input  wire        we3,
               input  wire [4:0]  a1, a2, a3,   //address inputs(2^5=32)
               input  wire [31:0] wd3,          //write data port 3, 32 bit value that gets stored in register a3 when we3=1
               output wire [31:0] rd1, rd2);    

    reg [31:0] rf[31:0];        //array of registers , 32 bit 32 registers 
    // register 0 is hardwired to 0
    always @(posedge clk)
        if (we3) rf[a3] <= wd3;   //in posedge , store wd3 to any reg that a3 is pointing to 
                                  //if we3 is low block does nothing
    assign rd1 = (a1 != 0) ? rf[a1] : 0;     
    assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule
