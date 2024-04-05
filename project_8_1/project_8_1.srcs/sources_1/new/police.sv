`timescale 1ns / 1ps
module police(
    input clk,
    output R, B
    );
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7= 7;
    reg [2:0] state;
    always_ff @(posedge clk)
        case(state)
            S0: state <= S1;
            S1: state <= S2;
            S2: state <= S3;
            S3: state <= S4;
            S4: state <= S5;
            S5: state <= S6;
            S6: state <= S7;
            S7: state <= S0;
            default: state <= S0;
        endcase
    assign R = (state == S0 || state == S2 || state == S4 || state == S6);
    assign B = (state == S1 || state == S3 || state == S4 || state == S6);
endmodule
