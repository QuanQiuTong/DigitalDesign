`timescale 1ns / 1ps
module HeartBeat(
    input CLK100MHZ,
    output logic [6:0] A2G,
    output DP,
    output logic [7:0] AN
    );
    reg [30:0] count;
    always @(posedge CLK100MHZ)
        count <= count + 1;

    reg [7:0] disp;
    always_comb case (count[27:26])
        0: disp = 8'b00011000;
        2: disp = 8'b10000001;
        default: disp = 8'b00100100;
    endcase
    
    always_comb case (count[19:18])
        0: begin A2G = sevenSeg(disp[1:0]); AN = 8'b11111110; end
        1: begin A2G = sevenSeg(disp[3:2]); AN = 8'b11111101; end
        2: begin A2G = sevenSeg(disp[5:4]); AN = 8'b11111011; end
        3: begin A2G = sevenSeg(disp[7:6]); AN = 8'b11110111; end
    endcase

    assign DP = 1;

    function[6:0] sevenSeg(input [1:0] in);
        case(in)
            1: sevenSeg = 7'b1001111;
            2: sevenSeg = 7'b1111001;
            default: sevenSeg = 7'b1111111;
        endcase
    endfunction
    
endmodule
