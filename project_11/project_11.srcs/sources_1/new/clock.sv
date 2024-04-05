module OneSecond(
    input wire clk, clr,
    output reg OneSecond
    );
    parameter N = 100_000_000 - 1;
    reg [31:0] counter;
    always @(posedge clk, posedge clr)
        if (clr) counter <= 0;
        else begin
            OneSecond <= 0;
            if (counter < N) counter <= counter + 1;
            else begin
                counter <= 0;
                OneSecond <= 1;
            end
        end
endmodule

module Count #(N = 60)
    (input clk, clr,
    output reg [7:0] Q,
    output reg CO);
    always @(posedge clk, posedge clr)
        if (clr) Q <= 0;
        else if (Q < N - 1) begin Q <= Q + 1; CO <= 0; end
        else begin Q <= 0; CO <= 1; end
endmodule

//module Clock60(
//    input wire clk, reset_n,
//    output reg [7:0] Q,
//    output CO
//    );

//    wire Clr_n1, Clr_n2, T;
//    assign Clr_n1 = ~(Q[5] & Q[6]) & reset_n;
//    assign Clr_n2 = ~(Q[1] & Q[3]) & reset_n;
//    assign T = Q[0] & Q[3];

//    _74LS161 A1(
//        .Clk(clk), .Clr_n(Clr_n1), .LD_n(1'b1), .P(1'b1), .T(T),
//        .D(4'b0000),
//        .Q(Q[7:4]), .CO(CO)
//    ),
//    A2(
//        .Clk(clk), .Clr_n(Clr_n2), .LD_n(1'b1), .P(1'b1), .T(1'b1),
//        .D(4'b0000),
//        .Q(Q[3:0]), .CO()
//    );

//endmodule

