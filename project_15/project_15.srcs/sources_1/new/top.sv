module screen_pic_Top(
   input  logic CLK100MHZ, BTND, //为了操作方便
    input  logic BTNU, BTNC,    // 控制Bar上下
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

    logic [16:0] addr17;
    logic [11:0] data;
    
    // ROM : 给地�?，就输出�?个像素的12位颜色�??
    Fudan320x320 F1(.clka(clk25MHz), //与VGA640x480模块clk�?�?
                    .addra(addr17),  // input [16:0]
                    .douta(data) );  // output [11:0]-12位颜�?      
   
    pingpong_screen_textBig P1(.clk(clk60Hz), .reset(BTND),
                    .btnUp(BTNU), .btnDown(BTNC),
                    .videoOn(videoOn), 
                    .pix_x(pixel_x), .pix_y(pixel_y), 
                    .red(VGA_R),         // Output ***
                    .green(VGA_G),       // Output ***
                    .blue(VGA_B),        // Output ***
                    .picData(data),
                    .picAddr17(addr17)); // Output                                         
endmodule

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