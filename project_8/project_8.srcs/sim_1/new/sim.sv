`timescale 1ns / 1ps
module sim( );
    logic clk,j,k,q,q2,q3;
    JKFF jkff(clk,j,k,q);
    JKFF2 jkff2(clk,j,k,q2);
    JKFF3 jkff3(clk,j,k,q3);
    initial begin
        #0 q = 1; q2 = 1; q3 = 1;
        #10 j=1'b0;k=1'b0;clk=1'b0;
        #10 j=1'b0;k=1'b0;clk=1'b1;
        #10 j=1'b0;k=1'b1;clk=1'b0;
        #10 j=1'b0;k=1'b1;clk=1'b1;
        #10 j=1'b1;k=1'b0;clk=1'b0;
        #10 j=1'b1;k=1'b0;clk=1'b1;
        #10 j=1'b1;k=1'b1;clk=1'b0;
        #10 j=1'b1;k=1'b1;clk=1'b1;
        #10 $finish;
    end
endmodule
