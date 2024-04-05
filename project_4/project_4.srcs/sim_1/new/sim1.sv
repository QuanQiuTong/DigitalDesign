`timescale 1ns / 1ps

module sim1( );
    logic [15:0] SW, LED;
    logic [6:0] A2G;
    logic [7:0] AN;
    logic DP, LED16_G, LED16_R;

    top1 top(0, SW, LED, A2G, AN, DP, LED16_G, LED16_R);

    initial begin
        # 0  SW = 'h2023;
        # 10 SW = 'h2022;
        # 10 SW = 'h2021;
        # 10 SW = 'h2020;
        # 10 SW = 'h2000;
        # 10 SW = 'h1900;
        # 10 SW = 'h1800;
        # 10 SW = 'h1700;
        # 10 SW = 'h1600;
    end
endmodule