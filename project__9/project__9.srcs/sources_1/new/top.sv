`timescale 1ns / 1ps

module top(
    input CLK100MHZ, BTNC, BTNU, BTNL, BTNR, BTND,
    input [7:0] SW,
    output [7:0] LED,
    output LED16_G, LED16_R
    );
    wire clkDiv, pulse;
    clkDiv ___(CLK100MHZ, BTNC, clkDiv);
    clkPulse __(clkDiv, BTNC, BTNU | BTNL | BTNR | BTND, pulse);

    // 4-2 encoder
    reg [1:0] digit;
    always_comb 
        case ({BTNU, BTNL, BTNR, BTND})
            4'b1000: digit = 2'b00;
            4'b0100: digit = 2'b01;
            4'b0010: digit = 2'b10;
            4'b0001: digit = 2'b11;
            // default: digit = digit;
        endcase
    
    lock _(pulse, BTNC, digit, SW, LED16_G, LED16_R);

    assign LED[7:0] = SW;
endmodule
