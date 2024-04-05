`timescale 1ns / 1ps

module top1(
    input  logic        CLK100MHZ,
    input  logic [15:0] SW,
    output logic [15:0] LED,
    output logic [6:0]  A2G,
    output logic [7:0]  AN,
    output logic        DP,
    output logic        LED16_G,
    output logic        LED16_R
);
    x7seg x7(SW, CLK100MHZ, A2G, AN, DP);

    logic [15:0] year;
    assign year = {12'b0,SW[15:12]}*1000+{12'b0,SW[11:8]}*100+{12'b0,SW[7:4]}*10+{12'b0,SW[3:0]};

    always_comb
        if(year%400==0||year%4==0&&year%100!=0) begin
            LED16_G = 1;
            LED16_R = 0;
        end
        else begin
            LED16_G = 0;
            LED16_R = 1;
        end

    assign LED = SW;
endmodule
