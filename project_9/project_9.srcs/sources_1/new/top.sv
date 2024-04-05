`timescale 1ns / 1ps

module top(
    input CLK100MHZ, BTNC, BTNU, BTNL, BTNR, BTND,
    input [7:0] SW,
    output [7:0] LED,
    output LED16_G, LED16_R, LED17_G, LED17_R  
    );
    reg clr, pass;
    reg [1:0] digit;
    decoder dec (BTNC, BTNU, BTNL, BTNR, BTND, clr, digit);
    
    logic [4:0] state;
    lock _(CLK100MHZ, clr, digit, SW, pass, state);

    assign LED = SW;
    assign LED16_G = pass;
    assign LED16_R = ~pass;
    assign LED17_G = ~pass;
    assign LED17_R = pass;

endmodule

module decoder (
    input c, u, l, r, d,
    output reg clr,
    output reg [1:0] digit
    );
    always_comb 
        case ({c, u, l, r, d})
            5'b10000: begin clr = 1'b1; digit = 2'b00; end
            5'b01000: begin clr = 1'b0; digit = 2'b00; end
            5'b00100: begin clr = 1'b0; digit = 2'b01; end
            5'b00010: begin clr = 1'b0; digit = 2'b10; end
            5'b00001: begin clr = 1'b0; digit = 2'b11; end
        endcase
endmodule