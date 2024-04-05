`timescale 1ns / 1ps

module sim_b2g( );
    logic [3:0] bin, gray, b, g;
    Bin2Gray b2g(bin, gray);
    bin_to_gray b_t_g(b, g);
    initial begin
        #0  bin = 4'b0000; b = 4'b0000;
        #10 bin = 4'b0001; b = 4'b0001;
        #10 bin = 4'b0010; b = 4'b0010;
        #10 bin = 4'b0011; b = 4'b0011;
        #10 bin = 4'b0100; b = 4'b0100;
        #10 bin = 4'b0101; b = 4'b0101;
        #10 bin = 4'b0110; b = 4'b0110;
        #10 bin = 4'b0111; b = 4'b0111;
        #10 bin = 4'b1000; b = 4'b1000;
        #10 bin = 4'b1001; b = 4'b1001;
        #10 bin = 4'b1010; b = 4'b1010;
        #10 bin = 4'b1011; b = 4'b1011;
        #10 bin = 4'b1100; b = 4'b1100;
        #10 bin = 4'b1101; b = 4'b1101;
        #10 bin = 4'b1110; b = 4'b1110;
        #10 bin = 4'b1111; b = 4'b1111;
    end
endmodule
