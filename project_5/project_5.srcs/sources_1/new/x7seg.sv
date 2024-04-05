`timescale 1ns / 1ps

module x7seg (
    input  logic [31:0] data,
    input  logic        clk,
    output logic [6:0]  a2g,
    output logic [7:0]  an, 
    output logic        dp  
) ;
    logic [3:0] char;
    logic [20:0] clkdiv;

    assign dp = 1;             

    always_comb
        case(clkdiv[20: 18])
            0: char = data[3:0];
            1: char = data[7:4];
            2: char = data[11:8];
            3: char = data[15:12];
            4: char = data[19:16];
            5: char = data[23:20];
            6: char = data[27:24];
            7: char = data[31:28];
        endcase

    _74LS138 _(clkdiv[20: 18], 3'b001, an);

    always @(posedge clk)
        clkdiv <= clkdiv + 1;

    Hex7Seg s7(char, a2g);
endmodule