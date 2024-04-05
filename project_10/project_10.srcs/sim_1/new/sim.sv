`timescale 1ns / 1ps
module sim();
    // logic reset, clk15, clk45;
    // logic [1:0] ns, ew;
    // Control _(reset, clk15, clk45, ns, ew);
    // initial begin
    //     clk15 = 0; clk45 = 0;
    //     reset = 0; #1; reset = 1; #9; reset = 0;
    //     forever begin
    //         #45 clk45 = 1; #1 clk45 = 0;
    //         #15 clk15 = 1; #1 clk15 = 0;
    //     end
    // end

    logic clk1hz, BTNC;
    logic [1:0] LED16, LED17;
    wire clk15, clk45;
    clkDiv cdiv(BTNC, clk1hz, clk15, clk45);
    Control ctrl(BTNC, clk15, clk45, LED16, LED17);
    initial begin
        clk1hz = 0; BTNC = 0;
        #1 BTNC = 1; #4 BTNC = 0;
        forever
            #1 clk1hz = ~clk1hz;
    end
endmodule
