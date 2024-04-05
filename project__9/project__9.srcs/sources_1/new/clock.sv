module clkDiv #(parameter int N = 19) (
    input clk, clr,
    output clkDiv
    );
    reg [N-1:0] cnt;
    always @(posedge clk, posedge clr)
        if(clr) cnt <= 0;
        else cnt <= cnt + 1;
    assign clkDiv = cnt[N-1];
endmodule

module clkPulse (
    input clk, clr, inp,
    output outp
    );
    reg delay1, delay2, delay3;

    always_ff @(posedge clk, posedge clr)
        if(clr) begin
            delay1 <= 0;
            delay2 <= 0;
            delay3 <= 0;
        end
        else begin
            delay1 <= inp;
            delay2 <= delay1;
            delay3 <= ~delay2;
        end
    
    assign outp = delay1 & delay2 & delay3;
endmodule