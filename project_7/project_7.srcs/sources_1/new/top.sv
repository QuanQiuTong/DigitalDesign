`timescale 1ns / 1ps

module top(
    input  logic  CLK100MHZ,
    input  logic [15:0] SW,
    output [15:0] LED,
    output [6:0]  A2G,
    output [7:0]  AN,
    output        DP
    );
    // logic [7:0] prod, bcd;
    // mult _(CLK100MHZ, SW[15:12], SW[3:0], prod);
    // Bin2BCD b2b(prod, bcd);
    // SevenSegmentDisplay ssd({SW[15:12],'ha,SW[3:0],'hb,bcd,'hff}, CLK100MHZ, A2G, AN, DP);
    
    logic [7:0] prod;
    logic [31:0] disp;
    mult _(CLK100MHZ, SW[15:12], SW[3:0], prod);
    Bin2BCD b2b(prod,{2'bzz, disp[15:8]});
    assign disp[31:28] = SW[15:12];
    assign disp[27:24] = 'ha;
    assign disp[23:20] = SW[3:0];
    assign disp[19:16] = 'hb;
    assign disp[7:0] = 'hff;
    SevenSegmentDisplay ssd(disp, CLK100MHZ, A2G, AN, DP);

    assign LED = SW;
endmodule
