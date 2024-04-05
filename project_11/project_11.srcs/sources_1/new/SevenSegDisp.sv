module ClockDisp(
    input CLK100MHZ,
    input [7:0] second, minute, hour,
    output logic [6:0] A2G,
    output DP,
    output logic [7:0] AN
    );
    reg [30:0] count;
    always @(posedge CLK100MHZ)
        count <= count + 1;
    
    always_comb case (count[19:17])
        0: begin A2G = sevenSeg(second[3:0]); AN = 8'b11111110; end
        1: begin A2G = sevenSeg(second[7:4]); AN = 8'b11111101; end
        2: begin A2G = sevenSeg('hf); AN = 8'b11111011; end
        3: begin A2G = sevenSeg(minute[3:0]); AN = 8'b11110111; end
        4: begin A2G = sevenSeg(minute[7:4]); AN = 8'b11101111; end
        5: begin A2G = sevenSeg('hf); AN = 8'b11011111; end
        6: begin A2G = sevenSeg(hour[3:0]); AN = 8'b10111111; end
        7: begin A2G = sevenSeg(hour[7:4]); AN = 8'b01111111; end
    endcase

    assign DP = 1;

    function[6:0] sevenSeg(input [3:0] char);
        case(char)
            0: sevenSeg = 7'b0000001;
            1: sevenSeg = 7'b1001111;
            2: sevenSeg = 7'b0010010;
            3: sevenSeg = 7'b0000110;
            4: sevenSeg = 7'b1001100;
            5: sevenSeg = 7'b0100100;
            6: sevenSeg = 7'b0100000;
            7: sevenSeg = 7'b0001111;
            8: sevenSeg = 7'b0000000;
            9: sevenSeg = 7'b0000100;
            default: sevenSeg = 7'b1111110; // -
        endcase
    endfunction
endmodule
