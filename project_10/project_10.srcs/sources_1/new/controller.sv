module clkDiv (
    input reset, clk,
    output clk15, clk45
    );
    reg [5:0] count;
    always @(posedge reset, posedge clk)
        if(reset || count == 59) count <= 0;
        else count <= count + 1;
    assign clk15 = count == 1;
    assign clk45 = count == 16;
endmodule

module clkPulse(
    input clk, reset, in,
    output wire pulse
    );
    reg delay1, delay2, delay3;
    always @(posedge clk, posedge reset)
        if(reset) begin delay1 <= 0; delay2 <= 0; delay3 <= 0; end
        else begin
            delay1 <= in; delay2 <= delay1; delay3 <= ~delay2;
        end
    assign pulse = delay1 & delay2 & delay3;
endmodule

module Control(
    input reset, clk15, clk45,
    output reg [1:0] ns, ew // 'b10 denotes red, 'b01 denotes green, 'b11 denotes yellow
    );
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    reg [1:0] state;
    always @(posedge reset, posedge clk15, posedge clk45)
    if(reset) begin state = S0; ns = 1; ew = 2; end
    else case (state)
        S0: if(clk45) begin state = S1; ns = 3; ew = 2; end
        S1: if(clk15) begin state = S2; ns = 2; ew = 1; end
        S2: if(clk45) begin state = S3; ns = 2; ew = 3; end
        S3: if(clk15) begin state = S0; ns = 1; ew = 2; end
    endcase
endmodule
