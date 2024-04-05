`timescale 1ns / 1ps

module latch(
    input logic en,
    input logic d,
    output logic q
    );
    always_latch 
        if(en) q <= d;
endmodule

module DFF(
    input logic clk,
    input logic d,
    output logic q
    );
    always_ff @(posedge clk) q <= d;
endmodule

module JKFF(
    input logic clk,
    input logic j, k,
    output logic q
    );
    // always_ff @(posedge clk) begin
    //     if(~j & ~k) q <= q;
    //     else if(j) q <= 1'b1;
    //     else if(k) q <= 1'b0;
    //     else q <= ~q;
    // end
    logic qbar,t1,t2;
    assign qbar = ~q;
    assign t1 = j & qbar;
    assign t2 = ~k & q;
    // DFF _(clk,t1|t2,q);
    always_ff @(posedge clk)
        q <= (j & ~q) | (~k & q);
    
endmodule

module JKFF3(
    input logic clk,
    input logic j, k,
    output logic q
    );
    always_ff @(posedge clk) begin
        if(j && !k) q <= 1;
        else if(!j && k) q <= 0;
        else if(j && k) q <= ~q;
    end
endmodule

module JKFF2(
    input logic clk,
    input logic j, k,
    output logic q
    );
    always_ff @(posedge clk)
        q <= (j & ~q) | (~k & q);
endmodule