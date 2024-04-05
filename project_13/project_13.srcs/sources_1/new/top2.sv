module pingpong_screen_move_Top(
    input  logic CLK100MHZ, BTND,  //为了操作方便
    input  logic BTNU, BTNC,       //控制Bar上下
    output logic VGA_HS, VGA_VS,
    output logic [3:0] VGA_R, VGA_G, VGA_B); 
    
    logic clk25MHz, clk60Hz, videoOn;
    logic [10:0] pixel_x, pixel_y; 

    clkDiv C1(.clk(CLK100MHZ), .clr(BTND), 
              .clk25MHz(clk25MHz));
    
    VGA640x480 V1(.clk(clk25MHz), .clr(BTND),  // Input
        .hSync(VGA_HS),   .vSync(VGA_VS),      // Output ***
        .xPixel(pixel_x), .yPixel(pixel_y),    // Output
        .displayOn(videoOn));                  // Output    
        
    clk60Hz C2(.clk(CLK100MHZ), .clr(BTND), .clk60Hz(clk60Hz));      
   
    pingpong_screen_move P1(.clk(clk60Hz), .reset(BTND),
                            .btnUp(BTNU), .btnDown(BTNC),
                            .videoOn(videoOn), 
                            .pix_x(pixel_x), 
                            .pix_y(pixel_y), 
                            .red(VGA_R),     // Output ***
                            .green(VGA_G),   // Output ***
                            .blue(VGA_B));   // Output ***
endmodule

module clk60Hz (
    input clk, clr,
    output logic clk60Hz);

    localparam 
        CNT_MAX = 1666667; // 100MHz / 60Hz = 1666666
    
    logic [31:0] cnt;

    always_ff @(posedge clk, posedge clr)
    begin
        if (clr)
            cnt <= 0;
        else if (cnt == CNT_MAX-1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    assign clk60Hz = (cnt == CNT_MAX-1);
    
endmodule
