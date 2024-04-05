`timescale 1ns / 1ps

module top(
    input CLK100MHZ, BTNC,
    output [1:0] LED16, LED17,
    );
    reg [25:0] count;
    wire clk1hz, clk15, clk45;
    always @(posedge BTNC, posedge CLK100MHZ)
        if(BTNC) count <= 0;
        else count <= count + 1;
    assign clk1hz = count[25];
    
    clkDiv cdiv(BTNC, clk1hz, clk15, clk45);
    Control ctrl(BTNC, clk15, clk45, LED16, LED17);
endmodule
