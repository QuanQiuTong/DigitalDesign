`timescale 1ns / 1ps

module top (
    input CLK100MHZ,
    input [15:0] SW,
    output logic [15:0] LED
    );
    logic [25:0] clkdiv;
    always @(posedge CLK100MHZ) 
        clkdiv <= clkdiv + 1;
    logic q;
    JKFF _(clkdiv[25], SW[15], SW[0], q);
    always_comb 
        if(q) LED = 'hff00;
        else  LED = 'h00ff;
endmodule