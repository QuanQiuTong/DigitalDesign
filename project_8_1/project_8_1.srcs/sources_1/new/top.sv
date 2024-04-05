`timescale 1ns / 1ps

module top(
    input CLK100MHZ,
    output LED16_B, LED17_R
    );
    logic [23:0] counter;
    always @(posedge CLK100MHZ)
        counter <= counter + 1;
    police _(counter[23], LED17_R, LED16_B);
endmodule
