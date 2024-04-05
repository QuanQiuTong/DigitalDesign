module top(
    input CLK100MHZ, BTNC,
    output [6:0] A2G,
    output DP,
    output [7:0] AN
    );
    wire _1s, _1m, _1h;
    reg [7:0] second, minute, hour;
    reg [9:0] sec, min, hr;
    OneSecond u1(CLK100MHZ, BTNC, _1s);
    Count #(60) s1(.clk(_1s), .clr(BTNC), .Q(second), .CO(_1m));
    Count #(60) m1(.clk(_1m), .clr(BTNC), .Q(minute), .CO(_1h));
    Count #(24) h1(.clk(_1h), .clr(BTNC), .Q(hour), .CO());
    Bin2BCD s2(.bin(second), .bcd(sec));
    Bin2BCD m2(.bin(minute), .bcd(min));
    Bin2BCD h2(.bin(hour), .bcd(hr));
    ClockDisp _(CLK100MHZ, sec, min, hr, A2G, DP, AN);
endmodule
