`timescale 1ns / 1ps
module mult(
    input  wire         CLK,
    input  wire [3 : 0] A,
    input  wire [3 : 0] B,
    output wire [7 : 0] P
    );
    mult_gen_0 _(CLK, A, B, P);
endmodule
