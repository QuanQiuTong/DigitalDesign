`timescale 1ns / 1ps

module x7seg (
    input  logic [39:0] disp,
    input  logic        clk,
    output logic [6:0]  a2g,
    output logic [7:0]  an, 
    output logic        dp  
) ;
    logic [2:0] s;
    logic [4:0] char;
    logic [20:0] clkdiv;

    assign dp = 1;             
    assign s = clkdiv[20: 18] ; // count every 10.4ms

    always_comb
        case(s)
            0: char = disp[4:0];
            1: char = disp[9:5];
            2: char = disp[14:10];
            3: char = disp[19:15];
            4: char = disp[24:20];
            5: char = disp[29:25];
            6: char = disp[34:30];
            7: char = disp[39:35];
            default: char = 5'b11111;
        endcase

    always_comb
        case(s)
            0: an=8'b11111110;
            1: an=8'b11111101;
            2: an=8'b11111011;
            3: an=8'b11110111;
            4: an=8'b11101111;
            5: an=8'b11011111;
            6: an=8'b10111111;
            7: an=8'b01111111;
            default: an=8'b11111111;
        endcase

    always @(posedge clk)
        clkdiv <= clkdiv + 1;

    Hex7Seg s7(char, a2g);
endmodule