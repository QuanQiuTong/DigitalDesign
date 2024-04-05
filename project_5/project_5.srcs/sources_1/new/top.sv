`timescale 1ns / 1ps

module top(
    input  logic         CLK100MHZ,
    input  logic [15:12] SW,
    output logic [15:12] LED,
    output logic [6:0]   A2G,
    output logic         DP,
    output logic [7:0]   AN
);
    logic [3:0] gray;
    Bin2Gray b2g(SW[15:12], gray);
    x7seg x7(
        {3'b000,SW[15],3'b000,SW[14],3'b000,SW[13],3'b000,SW[12],3'b000,gray[3],3'b000,gray[2],3'b000,gray[1],3'b000,gray[0]},
        CLK100MHZ, A2G, AN, DP
    );
    assign LED[15:12] = SW[15:12];
endmodule
