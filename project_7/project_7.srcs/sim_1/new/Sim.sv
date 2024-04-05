`timescale 1ns / 1ps
module Sim( );
    logic [3:0] a, b;
    logic [7:0] c;
    logic CLK;
    mult _(CLK,a,b,c);
    initial begin
        #0 a = 4'b0000;b=4'b0000;CLK=0;
        #10 a = 4'b0001;b=4'b0001;CLK=1;
        #10 a = 4'b0010;b=4'b0010;CLK=0;
        #10 a = 4'b0011;b=4'b0011;CLK=1;
        #10 a = 4'b0100;b=4'b0100;CLK=0;
        #10 a = 4'b0101;b=4'b0101;CLK=1;
        #10 a = 4'b0110;b=4'b0110;
        #10 a = 4'b0111;b=4'b0111;
        #10 a = 4'b1000;b=4'b1000;
        #10 a = 4'b1001;b=4'b1001;
    end
endmodule 