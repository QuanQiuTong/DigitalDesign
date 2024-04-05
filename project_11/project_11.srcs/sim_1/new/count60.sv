`timescale 1ns / 1ps

module count60_sim();
    logic clk, reset_n, Clr_n1, Clr_n2, T, CO1, CO2;
    logic [7:0] Q;
    assign Clr_n1 = ~(Q[5] & Q[6]) & reset_n;
    assign Clr_n2 = ~(Q[1] & Q[3]) & reset_n;
    assign T = Q[0] & Q[3];

    _74LS161 A1(
        .Clk(clk), .Clr_n(Clr_n1), .LD_n(1'b1), .P(1'b1), .T(T),
        .D(4'b0000),
        .Q(Q[7:4]), .CO(CO1)
    ),
    A2(
        .Clk(clk), .Clr_n(Clr_n2), .LD_n(1'b1), .P(1'b1), .T(1'b1),
        .D(4'b0000),
        .Q(Q[3:0]), .CO(CO2)
    );

    initial begin
        clk = 0;
        reset_n = 0; #2 reset_n = 1;
    end

    always #5 clk = ~clk;
endmodule
