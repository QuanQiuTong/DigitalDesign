module pingpong_screen_still( input  logic videoOn,
    input  logic [10:0] pix_x, pix_y, //扫描屏幕坐标
    output logic [3:0] red, green, blue );
     
    localparam 
      MAX_X = 640,  MAX_Y = 480,  //(0.0) to (639,479)
      // 屏幕参数
      H_SYNC    =  96, // horizontal sync width
      H_BACK    =  48, // left border (back porch) 
      H_SYNC_START = H_SYNC + H_BACK, //行显示后�? = 144(96+48)
      V_SYNC    =   2, // vertical sync lines
      V_TOP     =  29, // vertical top border  
      V_SYNC_START = V_SYNC + V_TOP, //场显示后�? =  31(2+29)   
      // === wall === 
      WALL_X_L = H_SYNC_START + 30, // left boundary
      WALL_X_R = H_SYNC_START + 40, // right boundary  
      // === bar === 
      BAR_X_L = H_SYNC_START + 600, // left boundary
      BAR_X_R = H_SYNC_START + 605, // right boundary   
      BAR_Y_SIZE = 70,              // bar 的高�?
      BAR_Y_T = V_SYNC_START + MAX_Y/2 - BAR_Y_SIZE/2, //Top=204 
      BAR_Y_B = BAR_Y_T + BAR_Y_SIZE -1, // bottom boundary   
      // === ball ===
      BALL_SIZE = 8, 
      BALL_X_L = H_SYNC_START + 580,       // left boundary 
      BALL_X_R = BALL_X_L + BALL_SIZE - 1, // right boundary 
      BALL_Y_T = V_SYNC_START + MAX_Y/2 -BALL_SIZE/2,//top boundary 
      BALL_Y_B = BALL_Y_T + BALL_SIZE - 1;       // bottom boundary 
         
    logic wallOn, barOn, ballOn; 
    logic [3:0] wall_r, wall_g, wall_b;
    logic [3:0] bar_r,  bar_g,  bar_b; 
    logic [3:0] ball_r, ball_g, ball_b;
      
    // (wall) : pixel within wall 
    assign wallOn = (WALL_X_L <= pix_x) && (pix_x <= WALL_X_R); 
    assign wall_r = 4'b0000; 
    assign wall_g = 4'b0000; 
    assign wall_b = 4'b1111; // blue
    
    // (bar) :  pixel within bar 
    assign barOn = ((BAR_X_L<=pix_x) && (pix_x<=BAR_X_R) &&
                    (BAR_Y_T<=pix_y) && (pix_y<=BAR_Y_B));
    assign bar_r = 4'b0000; 
    assign bar_g = 4'b1111; // green
    assign bar_b = 4'b0000; 
       
    // (ball): pixel within squared ball 
    assign ballOn = ((BALL_X_L<=pix_x) && (pix_x<=BALL_X_R) && 
                     (BALL_Y_T<=pix_y) && (pix_y<=BALL_Y_B));
    assign ball_r = 4'b1111; // red
    assign ball_g = 4'b0000; 
    assign ball_b = 4'b0000; 
        
    always_comb   // ===== rgb 输出 ======
        if (~videoOn) 
        begin
            red   = 4'b0000; // blank
            green = 4'b0000; // blank
            blue  = 4'b0000; // blank
        end
        else if (wallOn)
        begin
            red   = wall_r;
            green = wall_g; 
            blue  = wall_b; 
        end
        else if (ballOn)
        begin
            red   = ball_r;
            green = ball_g;
            blue  = ball_b;
        end
        else if (barOn)
        begin
            red   = bar_r;
            green = bar_g;
            blue  = bar_b;
        end
        else
        begin // gray background
            red   = 4'b1110; 
            green = 4'b1110; 
            blue  = 4'b1110; 
        end
endmodule

module pingpong_screen_stillR(
    input  logic videoOn,
    input  logic [10:0] pix_x, pix_y, //扫描屏幕坐标
    output logic [3:0] red, green, blue );
     
    localparam 
      MAX_X = 640,  MAX_Y = 480,  //(0.0) to (639,479)
      // 屏幕参数
      H_SYNC    =  96, // horizontal sync width
      H_BACK    =  48, // left border (back porch) 
      H_SYNC_START = H_SYNC + H_BACK, //行显示后�? = 144(96+48)
      V_SYNC    =   2, // vertical sync lines
      V_TOP     =  29, // vertical top border  
      V_SYNC_START = V_SYNC + V_TOP, //场显示后�? =  31(2+29)   
      // === wall === 
      WALL_X_L = H_SYNC_START + 30, // left boundary
      WALL_X_R = H_SYNC_START + 40, // right boundary  
      // === bar === 
      BAR_X_L = H_SYNC_START + 600, // left boundary
      BAR_X_R = H_SYNC_START + 605, // right boundary   
      BAR_Y_SIZE = 70,              // bar 的高�?
      BAR_Y_T = V_SYNC_START + MAX_Y/2 - BAR_Y_SIZE/2, //Top=204 
      BAR_Y_B = BAR_Y_T + BAR_Y_SIZE -1, // bottom boundary   
      // === ball ===
      BALL_SIZE = 8, 
      BALL_X_L = H_SYNC_START + 580,       // left boundary 
      BALL_X_R = BALL_X_L + BALL_SIZE - 1, // right boundary 
      BALL_Y_T = V_SYNC_START + MAX_Y/2 -BALL_SIZE/2,//top boundary 
      BALL_Y_B = BALL_Y_T + BALL_SIZE - 1;       // bottom boundary 
         
    logic wallOn, barOn, ballOn, picOn; 
    logic [3:0] wall_r, wall_g, wall_b;
    logic [3:0] bar_r,  bar_g,  bar_b; 
    logic [3:0] ball_r, ball_g, ball_b;
      
    // (wall) : pixel within wall 
    assign wallOn = (WALL_X_L <= pix_x) && (pix_x <= WALL_X_R); 
    assign wall_r = 4'b0000; 
    assign wall_g = 4'b0000; 
    assign wall_b = 4'b1111; // blue
    
    // (bar) :  pixel within bar 
    assign barOn = ((BAR_X_L<=pix_x) && (pix_x<=BAR_X_R) &&
                    (BAR_Y_T<=pix_y) && (pix_y<=BAR_Y_B));
    assign bar_r = 4'b0000; 
    assign bar_g = 4'b1111; // green
    assign bar_b = 4'b0000; 
/*       
    // (ball): pixel within squared ball 
    assign ballOn = ((BALL_X_L<=pix_x) && (pix_x<=BALL_X_R) && 
                     (BALL_Y_T<=pix_y) && (pix_y<=BALL_Y_B));
    assign ball_r = 4'b1111; // red
    assign ball_g = 4'b0000; 
    assign ball_b = 4'b0000; 
*/    
    // ===  round ball ===
    logic [2:0] rom_addr, rom_col; // ROM�?8行�??8�?
    logic rom_bit;               // ROM中每个像素�??
    logic [7:0] rom_data;
    
    always_comb       // image ROM 
        case (rom_addr) 
            3'h0: rom_data = 8'b0011_1100; //   **** 
            3'h1: rom_data = 8'b0111_1110; //  ****** 
            3'h2: rom_data = 8'b1111_1111; // ******** 
            3'h3: rom_data = 8'b1111_1111; // ******** 
            3'h4: rom_data = 8'b1111_1111; // ******** 
            3'h5: rom_data = 8'b1111_1111; // ******** 
            3'h6: rom_data = 8'b0111_1110; //  ****** 
            3'h7: rom_data = 8'b0011_1100; //   **** 
        endcase  
    
    assign rom_col  = pix_x[2:0] - BALL_X_L[2:0]; // ROM�?
    assign rom_addr = pix_y[2:0] - BALL_Y_T[2:0]; // ROM�?
    assign rom_bit  = rom_data[rom_col]; //ROMaddr行中col列�??    
        
    // pixel within ball
    assign ballOn = ((BALL_X_L<=pix_x) && (pix_x<=BALL_X_R) &&  
                     (BALL_Y_T<=pix_y) && (pix_y<=BALL_Y_B)) &  
                     rom_bit;  // round ball
    assign ball_r = 4'b1111; // red
    assign ball_g = 4'b0000; // red
    assign ball_b = 4'b0000; // red     
        
    always_comb   // ===== rgb 输出 ======
        if (~videoOn) 
        begin
            red   = 4'b0000; // blank
            green = 4'b0000; // blank
            blue  = 4'b0000; // blank
        end
        else if (wallOn)
        begin
            red   = wall_r;
            green = wall_g; 
            blue  = wall_b; 
        end
        else if (ballOn)
        begin
            red   = ball_r;
            green = ball_g;
            blue  = ball_b;
        end
        else if (barOn)
        begin
            red   = bar_r;
            green = bar_g;
            blue  = bar_b;
        end
        else
        begin // gray background
            red   = 4'b1110; 
            green = 4'b1110; 
            blue  = 4'b1110; 
        end
endmodule
