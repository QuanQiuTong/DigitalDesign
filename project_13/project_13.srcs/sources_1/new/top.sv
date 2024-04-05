module pingpong_screen_still_Top(
    input  logic CLK100MHZ, BTND,  //为了操作方便
    output logic VGA_HS, VGA_VS,
    output logic [3:0] VGA_R, VGA_G, VGA_B); 
    
    logic clk25MHz, videoOn;
    logic [10:0] pixel_x, pixel_y; 

    clkDiv C1(.clk(CLK100MHZ), .clr(BTND), 
              .clk25MHz(clk25MHz));
    
    VGA640x480 V1(.clk(clk25MHz), .clr(BTND),  // Input
        .hSync(VGA_HS),   .vSync(VGA_VS),      // Output ***
        .xPixel(pixel_x), .yPixel(pixel_y),    // Output
        .displayOn(videoOn));                  // Output      
   
    pingpong_screen_still P1( .videoOn(videoOn), 
                              .pix_x(pixel_x), 
                              .pix_y(pixel_y), 
                              .red(VGA_R),     // Output ***
                              .green(VGA_G),   // Output ***
                              .blue(VGA_B));   // Output ***
endmodule

// ʱ�ӷ�Ƶ����: �ü�����ʵ��
module clkDiv(
    input  logic clk,
    input  logic clr,
    output logic clk25MHz );
    
    logic [1:0] q;  //reg
    // 2-bit counter
    always @(posedge clk, posedge clr)
        if(clr==1) q <= 0;
        else       q <= q + 1;

    assign clk25MHz = q[1]; // 100/4=25MHz
endmodule
