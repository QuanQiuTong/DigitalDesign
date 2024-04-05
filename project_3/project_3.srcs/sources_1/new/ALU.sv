module ALU(
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       c_in,
    input  logic [1:0] s,
    input  logic       m,
    output logic [3:0] f,
    output logic       c_out
);
    logic [4:0] tmp;

    always_comb begin
        case({m,s})
            3'b000: f = ~a;
            3'b001: f = a&b;
            3'b010: f = a|b;
            3'b011: f = a^b;
            3'b100: begin
                tmp = {1'b0,a}+{1'b0,b}+{4'b0000,c_in};
                f = tmp[3:0];
                c_out = tmp[4];
            end
            3'b101: begin
                tmp = {1'b0,a}-{1'b0,b}-{4'b0000,c_in};
                f = tmp[3:0];
                c_out = tmp[4];
            end
            default: tmp = a;
        endcase
    end
    
endmodule