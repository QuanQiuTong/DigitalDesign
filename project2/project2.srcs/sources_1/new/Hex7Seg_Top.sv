module Hex7Seg_Top (
    input   logic [3:0] SW,
    output  logic [6:0] A2G,
    output  logic [3:0] AN,
    output  logic       DP
);
    
    assign AN = 4'b0000;
    assign DP = 1;

    Hex7Seg S7(.data(SW), .a2g(A2G));
    
endmodule