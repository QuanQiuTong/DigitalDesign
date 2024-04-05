module VGA_colors_Top(
    input  CLK100MHZ, BTNC,
    input  [11:0] SW,
    output reg VGA_HS, VGA_VS, 
    output reg [3:0] VGA_R, VGA_G, VGA_B );
    
    logic clk25MHz;
    wire displayOn;
    reg [10:0] xPixel, yPixel;
    
    // clkDiv C1(.clk(CLK100MHZ), .clr(BTNC), .clk25MHz(clk25MHz));
    
    // VGA640x480 V1(.clk(clk25MHz), .clr(BTNC),       // Input
    //               .hSync(VGA_HS), .vSync(VGA_VS),   // Output
    //               .xPixel(xPixel), .yPixel(yPixel), // Output 
    //               .displayOn(displayOn));           // Output

    reg clk50MHz;
    always @(posedge CLK100MHZ)
        if (BTNC) clk50MHz <= 0;
        else clk50MHz <= ~clk50MHz;
    
    VGA800x600 V_(clk50MHz, BTNC, VGA_HS, VGA_VS, xPixel, yPixel, displayOn);

    assign VGA_R = (displayOn) ? SW[11:8] : 4'b0000;
    assign VGA_G = (displayOn) ? SW[ 7:4] : 4'b0000; 
    assign VGA_B = (displayOn) ? SW[ 3:0] : 4'b0000;

endmodule

