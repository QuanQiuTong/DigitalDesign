`timescale 1ns / 1ps

module Sim();
    logic clk, r, b;
    police _(clk, r, b);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
        
    end
endmodule
