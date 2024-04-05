module Hex7Seg (
    input   logic [4:0] data,
    output  logic [6:0] a2g
);
    always_comb 
        case (data)
            0: a2g = 7'b0000001;
            1: a2g = 7'b1001111;
            2: a2g = 7'b0010010;
            3: a2g = 7'b0000110;
            4: a2g = 7'b1001100;
            5: a2g = 7'b0100100;
            6: a2g = 7'b0100000;
            7: a2g = 7'b0001111;
            8: a2g = 7'b0000000;
            9: a2g = 7'b0000100;
            10: a2g = 7'b0001000;
            11: a2g = 7'b1100000;
            12: a2g = 7'b0110001;
            13: a2g = 7'b1000010;
            14: a2g = 7'b0110000;
            15: a2g = 7'b0111000;
            16: a2g = 7'b1001110; // +
            17: a2g = 7'b1110110; // =
            18: a2g = 7'b1111110; // -
        default: a2g = 7'b1111111; // nul
        endcase
endmodule