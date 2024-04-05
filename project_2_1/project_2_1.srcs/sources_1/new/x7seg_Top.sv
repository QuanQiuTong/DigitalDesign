module x7seg_Top(
    input  logic       CLK100MHZ,
    input  logic [0:0] SW,
    output logic [6:0] A2G,
    output logic [3:0] AN,
    output logic       DP
);

    x7seg x7(
        .x('h2023),
        .clk(CLK100MHZ),
        .clr(SW[0]),
        .a2g(A2G),
        .an(AN),
        .dp(DP)
    );
    
endmodule