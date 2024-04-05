module x7seg (
    input   logic [15:0] x,
    input   logic        clk,
    input   logic        clr,
    output  logic [6:0]  a2g,
    output  logic [3:0]  an, // 数码管使能
    output logic dp          // 小数点
) ;

    logic [1:0] s; // 选择哪个数码管
    logic [3:0] digit;
    logic [19:0] clkdiv;

    assign dp = 1;              // DP off
    assign s = clkdiv[19: 18] ; // count every 10.4ms

    // 4个数码管4选1(MUX44)
    always_comb
        case(s)
            0: digit = x[3:0];
            1: digit = x[7:4];
            2: digit = x[11:8];
            3: digit = x[15:12];
            default: digit = 'h0;
        endcase

    // 4个数码管的使能
    always_comb
        case(s)
            0: an=4'b1110;
            1: an=4'b1101;
            2: an=4'b1011;
            3: an=4'b0111;
            default: an = 4'b1111;
        endcase

    // 时钟分频器(20位二进制计数器)
    always @(posedge clk, posedge clr)
        if(clr == 1)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv + 1;

    // 实例化7段数码管
    Hex7Seg s7(.data(digit), .a2g(a2g));
endmodule