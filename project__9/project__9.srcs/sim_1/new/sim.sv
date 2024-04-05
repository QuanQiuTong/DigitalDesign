`timescale 1ns / 1ps
module sim();
    logic [7:0] SW, LED;
    logic C, U, L, R, D, red, green;
    logic [4:0] state;

    wire pass;
    reg [1:0] digit;
    always_comb 
        case ({U, L, R, D})
            4'b1000: digit = 2'b00;
            4'b0100: digit = 2'b01;
            4'b0010: digit = 2'b10;
            4'b0001: digit = 2'b11;
            // default: digit = digit;
        endcase
    lock _(U | L | R | D, C, digit, SW, green, red);

    initial begin
        SW = 8'b10001001;
        #10;
        C = 1; U = 0; L = 0; R = 0; D = 0; #10;
        C = 0; U = 0; L = 0; R = 0; D = 0; #10;

        C = 0; U = 0; L = 0; R = 1; D = 0; #10;
        C = 0; U = 0; L = 0; R = 0; D = 0; #10;

        C = 0; U = 1; L = 0; R = 0; D = 0; #10;
        C = 0; U = 0; L = 0; R = 0; D = 0; #10;

        C = 0; U = 0; L = 0; R = 1; D = 0; #10;
        C = 0; U = 0; L = 0; R = 0; D = 0; #10;

        C = 0; U = 0; L = 1; R = 0; D = 0; #10;
        C = 0; U = 0; L = 0; R = 0; D = 0; #10;

        #20;

        C = 1; U = 0; L = 0; R = 0; D = 0; #10;
        C = 0; U = 0; L = 0; R = 0; D = 0; #10;
    end  
endmodule
