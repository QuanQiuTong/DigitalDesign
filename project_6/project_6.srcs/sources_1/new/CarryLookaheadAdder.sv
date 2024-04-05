module SerialAdder(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] s,
    output logic cf
    );
    logic [4:0] c;
    assign c[0] = cin;
    assign s = a ^ b ^ c[3:0];
    assign c[4:1] = a & b | c[3:0] & (a ^ b);
    assign cf = c[4];
endmodule

module Adder4 (
    input [3:0] a,
    input [3:0] b,
    input        cin,
    output [3:0] s,
    output logic cf
    );
    logic [3:0] g, p;
    logic [4:0] c;
    assign g = a & b;
    assign p = a ^ b;
    assign c[0] = cin;
    assign c[1] = g[0] | p[0] & c[0];
    assign c[2] = g[1] | p[1] & (g[0] | p[0] & c[0]);
    assign c[3] = g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & c[0]));
    assign c[4] = g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & c[0])));
    assign s = a ^ b ^ c[3:0];
    assign cf = c[4];
endmodule

module Adder8(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output logic cf
    );
    logic c;
    Adder4 l(a[3:0], b[3:0], 1'b0, s[3:0], c),
           h(a[7:4], b[7:4], c,    s[7:4], cf);
endmodule
