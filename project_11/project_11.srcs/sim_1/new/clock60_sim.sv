`timescale 1ns / 1ps
module clock60_sim( );
    logic clk, reset;
    reg CO;
    reg [7:0] Q;

    Count #(60) A1(
        .clk(clk), .clr(reset), .Q(Q), .CO(CO)
    );
    
    initial begin
        clk = 0;
        reset = 0; #2 reset = 1;
    end
    
    always #5 clk = ~clk;
endmodule
