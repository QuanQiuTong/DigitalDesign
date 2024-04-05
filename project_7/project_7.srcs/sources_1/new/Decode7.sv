module Decode7(
    input   logic [4:0] data,
    output  logic [6:0] a2g
    );
    always_comb 
        case (data)
            'h0: a2g = 7'b0000001;
            'h1: a2g = 7'b1001111;
            'h2: a2g = 7'b0010010;
            'h3: a2g = 7'b0000110;
            'h4: a2g = 7'b1001100;
            'h5: a2g = 7'b0100100;
            'h6: a2g = 7'b0100000;
            'h7: a2g = 7'b0001111;
            'h8: a2g = 7'b0000000;
            'h9: a2g = 7'b0000100;
            'hA: a2g = 7'b1100010; // 'o'
            'hB: a2g = 7'b1110110; // '='
            default: a2g = 7'b1111111; // ' '
        endcase
endmodule
