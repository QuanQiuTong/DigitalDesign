`timescale 1ns / 1ps

module top2(
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

    // logic [3:0] YM, YH, YT, YO;
    // assign YM = SW[15:12];
    // assign YH = SW[]

    logic d_4, d_100, d_400;
    always_comb begin
        d_4 = ~SW[4]&~SW[1]&~SW[0] | SW[4]&SW[1]&~SW[0];
        d_100 = ~(|SW[7:0]);
        d_400 = d_100 & (~SW[12]&~SW[9]&~SW[8] | SW[12]&SW[9]&~SW[8]);
    end
    always_comb
        if(d_4&~d_100|d_400)begin
            LED16_G = 1;
            LED16_R = 0;
        end
        else begin
            LED16_G = 0;
            LED16_R = 1;
        end
    
    assign LED = SW;
endmodule
