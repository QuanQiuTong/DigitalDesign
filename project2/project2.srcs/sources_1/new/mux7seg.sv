module mux7seg (
    input  logic [3:0] SW,
    output logic [6:0] A2G,
    output logic [3:0] AN,
    output logic       DP
);

    logic [15:0] x;
    logic [3:0] digit;

    assign x = 'h1234;
    assign AN = ~SW;
    assign DP = 1; // DP off

    logic [1:0] s;
    assign s[1] = SW[2] | SW[3];
    assign s[0] = SW[1] | SW[3] ;

    //4位 4选1 MUX: mux44
    always_comb
        case(s)
            0: digit = x[3:0];
            1: digit = x[7:4];
            2: digit = x[11:8];
            3: digit = x[15:12];
            default: digit = x[3:0];
        endcase

    //实例化7段数码管
    Hex7Seg s7(.x(digit),.a2g(A2G)) ;

endmodule