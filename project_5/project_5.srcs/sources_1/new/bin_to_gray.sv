module bin_to_gray(
    input  logic [3:0] bin,
    output logic [3:0] gray
);
    assign gray = bin ^ {1'b0, bin[3:1]};
endmodule
