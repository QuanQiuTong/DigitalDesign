`timescale 1ns / 1ps
module sim();
    logic [7:0] SW, LED;
    logic clk, C, U, L, R, D, red, green, red2, green2, clr, pass, unpress;
    logic [1:0] digit;
    logic [4:0] state;
    // top _(clk, C, U, L, R, D, SW, LED, green, red, green2, red2);
    decoder dec(C, U, L, R, D, clr, digit);
    assign unpress = ~(C | U | L | R | D);
    lock lk(unpress, clr, digit, SW, pass, state);
    initial begin
        clk = 0;
        SW = 8'b10001001;
        C = 1; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;
        C = 0; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;

        C = 0; U = 0; L = 0; R = 1; D = 0; clk = 0; #5; clk = 1; #5;
        C = 0; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;

        C = 0; U = 1; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;
        C = 0; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;

        C = 0; U = 0; L = 0; R = 1; D = 0; clk = 0; #5; clk = 1; #5;
        C = 0; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;

        C = 0; U = 0; L = 1; R = 0; D = 0; clk = 0; #5; clk = 1; #5;
        C = 0; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;

        #15;

        C = 1; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;
        C = 0; U = 0; L = 0; R = 0; D = 0; clk = 0; #5; clk = 1; #5;
    end  
endmodule
