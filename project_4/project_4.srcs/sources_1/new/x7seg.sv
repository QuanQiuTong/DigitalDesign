module x7seg (
    input   logic [15:0] x,
    input   logic        clk,
    output  logic [6:0]  a2g,
    output  logic [7:0]  an,
    output  logic        dp
) ;
    logic [3:0] digit;
    logic [19:0] clkdiv;

    assign dp = 1;

    always_comb
        case(clkdiv[19: 18])
            0: digit = x[3:0];
            1: digit = x[7:4];
            2: digit = x[11:8];
            3: digit = x[15:12];
            default: digit = 'h0;
        endcase

    always_comb
        case(clkdiv[19: 18])
            0: an=8'b11111110;
            1: an=8'b11111101;
            2: an=8'b11111011;
            3: an=8'b11110111;
            default: an = 8'b11111111;
        endcase

    always @(posedge clk)
        clkdiv <= clkdiv + 1;

    Hex7Seg s7(digit, a2g);
endmodule