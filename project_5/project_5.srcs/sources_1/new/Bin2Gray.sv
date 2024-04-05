module Bin2Gray(
    input  [3:0] bin,
    output [3:0] gray
);
    logic [7:0] l, r;
    _74LS138 aL(bin[2:0], {1'b0, bin[3], 1'b1}, l),
             aR(bin[2:0], {2'b00, bin[3]}, r);
    assign gray[0] = !(&{l[2:1],l[6:5]})&!(&{r[2:1],r[6:5]});
    assign gray[1] = !(&l[5:2])&!(&r[5:2]);
    assign gray[2] = !(&l[7:4])&!(&r[3:0]);
    assign gray[3] = bin[3];
endmodule
