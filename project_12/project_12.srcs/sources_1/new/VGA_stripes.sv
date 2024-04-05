module VGA_Stripes_Top(
    input  logic CLK100MHZ, BTNC,
    output logic VGA_HS, VGA_VS, 
    output logic [3:0] VGA_R, VGA_G, VGA_B );
    
    logic clk25MHz, displayOn;
    logic [10:0] xPixel, yPixel;
    
    clkDiv C1(.clk(CLK100MHZ), .clr(BTNC), .clk25MHz(clk25MHz));
    
    VGA640x480 V1(.clk(clk25MHz), .clr(BTNC),        // Input
                  .hSync(VGA_HS), .vSync(VGA_VS),    // Output ***
                  .xPixel(xPixel), .yPixel(yPixel),  // Output 
                  .displayOn(displayOn));            // Output
        
    VGA_Stripes VS(.displayOn(displayOn), 
                   .xPixel(xPixel), .yPixel(yPixel),          // Input
                   .red(VGA_R), .green(VGA_G), .blue(VGA_B)); // Output ***
endmodule

module VGA_Stripes(
    input  logic displayOn,
    input  logic [10:0] xPixel, yPixel,
    output logic [3:0]  red, green, blue );
    
    //  =====  横彩条  ======
    assign red   =  {4{yPixel[4]}};
    assign green = ~{4{yPixel[4]}};
    assign blue  = 0;
    
//    //  =====  竖彩条  ======
//    assign red   =  {4{xPixel[4]}};
//    assign green = ~{4{xPixel[4]}};
//    assign blue  = 0;     
endmodule
