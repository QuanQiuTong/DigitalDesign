`timescale 1ns / 1ps

module SevenSegLED (
    input   logic [3:0] SW,
    output  logic [3:0] AN,
    output  logic       DP,
    output  logic [6:0] A2G
);
    
    assign AN = 4'b0000;
    assign DP = 1;
    
    always_comb 
        case (SW)
            'h0: A2G = 7'b0000001;
            'h1: A2G = 7'b1001111;
            'h2: A2G = 7'b0010010;
            'h3: A2G = 7'b0000110;
            'h4: A2G = 7'b1001100;
            'h5: A2G = 7'b0100100;
            'h6: A2G = 7'b0100000;
            'h7: A2G = 7'b0001111;
            'h8: A2G = 7'b0000000;
            'h9: A2G = 7'b0000100;
            'hA: A2G = 7'b0001000;
            'hB: A2G = 7'b1100000;
            'hC: A2G = 7'b0110001;
            'hD: A2G = 7'b1000010;
            'hE: A2G = 7'b0110000;
            'hF: A2G = 7'b0111000;
        default: A2G = 7'b0000001;//0
        endcase

endmodule

