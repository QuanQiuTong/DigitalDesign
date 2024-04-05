
module SRAM (
    input CE, OE, WE,
    input [12:0] A,
    output [7:0] D
    );
endmodule

module Storage (
    input OE, WE,
    input [13:0] A,
    output [15:0] D
    );
    SRAM _1(A[13], OE, WE, A[12:0], D[15:8]);
    SRAM _2(A[13], OE, WE, A[12:0], D[15:8]);
    SRAM _3(~A[13], OE, WE, A[12:0], D[7:0]);
    SRAM _4(~A[13], OE, WE, A[12:0], D[7:0]);
endmodule