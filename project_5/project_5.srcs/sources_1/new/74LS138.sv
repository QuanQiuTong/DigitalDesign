module _74LS138(
    input  logic [2:0] a,
    input  logic [3:1] s,
    output logic [7:0] y
);
    integer i;
    always@(*)
	    for(i = 0; i < 8; i = i + 1)
            y[i] = s == 3'b001 && a != i;

endmodule
