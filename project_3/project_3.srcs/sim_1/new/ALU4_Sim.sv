`timescale 1ns / 1ps

module ALU4_Sim( );
    logic       m, c_in, c_out;
    logic [2:0] s;
    logic [3:0] a, b, f;

    ALU alu(a, b, c_in, s, m, f, c_out);

    initial begin
        #0  m = 0;
            #0  s = 'b00; a = 8;
            #10 s = 'b01; a = 3; b = 'ha;
            #10 s = 'b10; a = 3; b = 'ha; 
            #10 s = 'b11; a = 3; b = 'ha;

        #10 m = 1;
            #0  s = 'b00; a = 5; b = 'ha; c_in = 0;
            #10 s = 'b00; a = 5; b = 'hb; c_in = 0; // 溢出
            #10 s = 'b00; a = 5; b = 'ha; c_in = 1;
            #10 s = 'b01; a = 'hc; b = 4; c_in = 0;
            #10 s = 'b01; a = 'hc; b = 4; c_in = 1;
    end
endmodule
