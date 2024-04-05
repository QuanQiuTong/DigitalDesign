module led (
    input logic [15:0] SW,
    output logic [15:0] LED
);
    assign LED[0] = SW[0];
    assign LED[15] = SW[15];
    assign LED[8] = SW[0] & SW[15];
endmodule
