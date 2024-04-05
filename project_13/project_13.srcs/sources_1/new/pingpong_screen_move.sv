module pingpong_screen_move(
    input  logic clk, reset,     //clk: 屏幕60Hz刷新频率
    input  logic btnUp, btnDown, //控制Bar上下移动
    input  logic videoOn,
    input  logic [10:0] pix_x, pix_y, //扫描屏幕坐标
    output logic [3:0] red, green, blue );
     
    localparam 
      MAX_X = 640,  MAX_Y = 480,  //(0.0) to (639,479)
      // 屏幕参数
      H_SYNC    =  96, // horizontal sync width
      H_BACK    =  48, // left border (back porch) 
      H_SYNC_START = H_SYNC + H_BACK, //行显示后沿 = 144(96+48)
      V_SYNC    =   2, // vertical sync lines
      V_TOP     =  29, // vertical top border  
      V_SYNC_START = V_SYNC + V_TOP, //场显示后沿 =  31(2+29)   
      // === wall === 
      WALL_X_L = H_SYNC_START + 30, // left boundary
      WALL_X_R = H_SYNC_START + 40, // right boundary  
      // === bar === 
      BAR_X_L = H_SYNC_START + 600, // left boundary
      BAR_X_R = H_SYNC_START + 605, // right boundary   
      BAR_Y_SIZE = 70,              // bar 的高度
      BAR_Y_T = V_SYNC_START + MAX_Y/2 - BAR_Y_SIZE/2, //Top=204 
      BAR_Y_B = BAR_Y_T + BAR_Y_SIZE -1, // bottom boundary 
      BAR_V = 4,                    // 每次移动 bar 的距离  
      // === ball ===
      BALL_SIZE = 8, 
      BALL_X_L = H_SYNC_START + 580,       // left boundary 
      BALL_X_R = BALL_X_L + BALL_SIZE - 1, // right boundary 
      BALL_Y_T = V_SYNC_START + MAX_Y/2 -BALL_SIZE/2,//top boundary 
      BALL_Y_B = BALL_Y_T + BALL_SIZE - 1,       // bottom boundary 
      BALL_V = 2;                          // 每次移动 ball 的距离
         
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
    logic [10:0] bar_y_t, bar_y_b; // bar top, bottom boundary
    
    // new bar y-position 
    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            bar_y_t <= BAR_Y_T;
        end
        else if (btnDown & (bar_y_b <= (V_SYNC_START+MAX_Y-1-BAR_V))) 
            bar_y_t <= bar_y_t + BAR_V; // move down 
        else if (btnUp & (bar_y_t >= (V_SYNC_START+BAR_V)))
            bar_y_t <= bar_y_t - BAR_V; // move up 
    end     

    assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1;
    
    assign barOn = ((BAR_X_L<=pix_x) && (pix_x<=BAR_X_R) &&
                    (bar_y_t<=pix_y) && (pix_y<=bar_y_b)); //变量
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
    // （round ball）    
    logic [10:0] ball_x_l, ball_x_r; // ball left, right boundary
    logic [10:0] ball_y_t, ball_y_b; // ball top, bottom boundary
    logic [10:0] ball_dx , ball_dy ; // ball x, y 增量 
        
    // new ball x,y-position 
    always @(posedge clk, posedge reset)    begin
        if (reset)   begin
            ball_x_l <= BALL_X_L;
            ball_y_t <= BALL_Y_T;
            ball_dx  <= -1 * BALL_V;
            ball_dy  <= -1 * BALL_V;
        end
        else   begin
            ball_x_l <= ball_x_l + ball_dx;
            ball_y_t <= ball_y_t + ball_dy;
            // ------------------ ball bounce back -----------------------
            if (ball_y_t <= V_SYNC_START)              //reach top screen
                ball_dy <= BALL_V;
            else if (ball_y_b >= V_SYNC_START + MAX_Y) //reach bottom screen 
                ball_dy <= -1 * BALL_V;
            else if (ball_x_l <= WALL_X_R)             //reach left wall 
                ball_dx <= BALL_V;                                       
            else if ((ball_x_r >= BAR_X_L) &&          //reach right bar
                     (ball_x_r <= BAR_X_R) &&   
                     (ball_y_b >= bar_y_t) &&  (ball_y_t <= bar_y_b))
                ball_dx <= -1 * BALL_V;                             
            else if (ball_x_r >= H_SYNC_START + MAX_X) //reach right screen
                ball_dx <= -1 * BALL_V;             
        end
     end               
        
     assign ball_x_r = ball_x_l + BALL_SIZE - 1; 
     assign ball_y_b = ball_y_t + BALL_SIZE - 1;
     
    logic [2:0] rom_addr, rom_col; // ROM中8行、8列
    logic rom_bit;                 // ROM中每个像素值
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
    
    assign rom_col  = pix_x[2:0] - ball_x_l[2:0]; // ROM列
    assign rom_addr = pix_y[2:0] - ball_y_t[2:0]; // ROM行
    assign rom_bit  = rom_data[rom_col]; //ROMaddr行中col列值  
         
    // pixel within ball
    assign ballOn = ((ball_x_l<=pix_x) && (pix_x<=ball_x_r) &&  //变量
                     (ball_y_t<=pix_y) && (pix_y<=ball_y_b)) &  //变量 
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
