`timescale 1ns/1ps

module football_Sim();
    logic [15:0] sw;
    logic [15:0] led;

    led A(.SW(sw), .LED(led));

    initial begin
        integer i;

        for(i=15;i>=0;i=i-1)
        sw[i]=0;

        for(i=15;i>=0;i=i-1)
        #10 sw[i]=1;
        
    end
endmodule
