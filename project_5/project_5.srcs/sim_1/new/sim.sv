`timescale 1ns / 1ps
module sim( );
    logic         clk;
    logic [15:12] sw, led;
    logic [6:0] a2g;
    logic dp;
    logic [7:0] an;

    top _(clk, sw, led, a2g, dp, an);

    initial begin
        #0  sw[15:12] = 4'b0000;
        #80 sw[15:12] = 4'b0001;
        #80 sw[15:12] = 4'b0010;
        #80 sw[15:12] = 4'b0011;
        #80 sw[15:12] = 4'b0100;
        #80 sw[15:12] = 4'b0101;
        #80 sw[15:12] = 4'b0110;
        #80 sw[15:12] = 4'b0111;
        #80 sw[15:12] = 4'b1000;
        #80 sw[15:12] = 4'b1001;
        #80 sw[15:12] = 4'b1010;
        #80 sw[15:12] = 4'b1011;
        #80 sw[15:12] = 4'b1100;
        #80 sw[15:12] = 4'b1101;
        #80 sw[15:12] = 4'b1110;
        #80 sw[15:12] = 4'b1111;
    end
endmodule
