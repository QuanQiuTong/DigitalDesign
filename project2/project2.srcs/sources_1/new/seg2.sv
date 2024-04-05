module x7seg_2 (
    input   logic [15:0] x,
    input   logic [15:0] x2,
    input   logic        clk,
    output  logic [6:0]  a2g,
    output  logic [7:0]  an, // �����ʹ��
    output  logic        dp  // С����
) ;

    logic [2:0] s; // ѡ��8�������֮һ
    logic [7:0] digit;
    logic [19:0] clkdiv;

    assign dp = 1;              // DP off
    assign s = clkdiv[19: 17] ; // count every 5.2ms

    // 8�������8ѡ1
    always_comb
        case(s)
            0: digit = x[3:0];
            1: digit = x[7:4];
            2: digit = x[11:8];
            3: digit = x[15:12];
            4: digit = x2[3:0];
            5: digit = x2[7:4];
            6: digit = x2[11:8];
            7: digit = x2[15:12];
            default: digit = x[3:0];
        endcase

    // 8������ܵ�ʹ��
    always_comb
        case(s)
            0: an=8'b11111110;
            1: an=8'b11111101;
            2: an=8'b11111011;
            3: an=8'b11110111;
            4: an=8'b11101111;
            5: an=8'b11011111;
            6: an=8'b10111111;
            7: an=8'b01111111;
            default: an=8'b11111110;
        endcase

    // ʱ�ӷ�Ƶ��(20λ�����Ƽ�����)
    always @(posedge clk)
        clkdiv <= clkdiv + 1;

    // ʵ����7�������
    Hex7Seg s7(.data(digit), .a2g(a2g));
endmodule