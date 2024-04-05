module x7seg_Top_2(
    input  logic       CLK100MHZ,
    input  logic [15:0] SW,
    output logic [6:0] A2G,
    output logic [7:0] AN,
    output logic       DP
);

    logic [15:0] x;
    assign x = SW;

    x7seg_2 x7(
        .x(x),
        .x2('h0118),
        .clk(CLK100MHZ),
        .a2g(A2G),
        .an(AN),
        .dp(DP)
    );

endmodule