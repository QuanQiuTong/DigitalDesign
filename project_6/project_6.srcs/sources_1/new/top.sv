`timescale 1ns / 1ps
module top(
    input  logic        CLK100MHZ,
    input  logic [15:0] SW,
    output logic [15:0] LED,
    output logic [6: 0] A2G,
    output logic [7: 0] AN,
    output logic        DP
    );
    logic [8:0] sum;
    Adder8 adder(SW[15:8], SW[7:0], sum[7:0], sum[8]);
    logic [31:0] disp;
    assign disp[15:12] = 'hf;
    Bin2BCD a(SW[15:8], disp[31:24]),
            b(SW[7: 0], disp[23:16]),
            s(sum[7:0], disp[9 : 0]);
    SevenSegmentDisplay ssd(disp, CLK100MHZ, A2G, AN, DP);
    assign LED = SW;
endmodule
