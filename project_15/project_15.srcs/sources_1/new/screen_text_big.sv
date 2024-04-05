module pingpong_screen_textBig(
    input  logic clk, reset,          //clk: 屏幕60Hz刷新频率
    input  logic btnUp, btnDown,      //控制Bar上下移动
    input  logic videoOn,
    input  logic [10:0] pix_x, pix_y, //屏幕坐标
    output logic [3:0]  red, green, blue, 
    input  logic [11:0] picData,   //每个像素用12位表示色彩
    output logic [16:0] picAddr17);//320x320=102,400bit.(2^17=131,072) 
     
    localparam 
      MAX_X = 640,  MAX_Y = 480,  //(0.0) to (640-1,480-1)
      // 屏幕参数
      H_SYNC    =  96,           // horizontal sync width
      H_BACK    =  48,           // left border (back porch) 
      H_SYNC_START = H_SYNC + H_BACK, //行显示后沿 = 144(96+48)
      V_SYNC    =   2,           // vertical sync lines
      V_TOP     =  29,           // vertical top border  
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
         
    logic wallOn, barOn, ballOn, picOn, textOn; 
    logic [3:0] wall_r, wall_g, wall_b;
    logic [3:0] bar_r,  bar_g,  bar_b; 
    logic [3:0] ball_r, ball_g, ball_b;
    logic [3:0] pic_r,  pic_g,  pic_b;
          
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

    // （round ball）    
    logic [10:0] ball_x_l, ball_x_r; // ball left, right boundary
    logic [10:0] ball_y_t, ball_y_b; // ball top, bottom boundary
    logic [10:0] ball_dx , ball_dy ; // ball x, y 增量 
    logic [3:0] textBalls0, textBalls1; // 得分个位,十位
    logic [2:0] ballCount;
    initial begin
        ballCount = 5;
    end
        
    // new ball x,y-position 
    always @(posedge clk, posedge reset)    begin
        if (reset)   begin
            ball_x_l <= BALL_X_L;
            ball_y_t <= BALL_Y_T;
            ball_dx  <= -1 * BALL_V;
            ball_dy  <= -1 * BALL_V;
            textBalls0 <= 4'b0000;   //得分个位
            textBalls1 <= 4'b0000;   //得分十位
            ballCount <= 5;
        end
        else   begin
            ball_x_l <= ball_x_l + ball_dx;  // 小球按clk节拍一直在向左移动
            ball_y_t <= ball_y_t + ball_dy;  // 小球按clk节拍一直在向上移动
            // ------------------ ball bounce back -----------------------
            if (ball_y_t <= V_SYNC_START)              //reach top screen
                ball_dy <= BALL_V;
            else if (ball_y_b >= V_SYNC_START + MAX_Y) //reach bottom screen 
                ball_dy <= -1 * BALL_V;
            else if (ball_x_l <= WALL_X_R)             //reach left wall 
            begin
                ball_dx <= BALL_V;  
            end                                    
            else if ((ball_x_r >= BAR_X_L) &&          //reach right bar
                     (ball_x_r <= BAR_X_R) &&   
                     (ball_y_b >= bar_y_t) &&  (ball_y_t <= bar_y_b))
            begin
                ball_dx <= -1 * BALL_V;     
                ball_x_l <= BAR_X_L - BALL_SIZE;//防止连续3次触发下行 hit+1      
                textBalls0 <= textBalls0 + 1;   //仅16进制+1            
            end
            else if (ball_x_r >= H_SYNC_START + MAX_X) //reach right screen
            begin
                ball_dx <= -1 * BALL_V;             
                ball_x_l <= H_SYNC_START + MAX_X - BALL_SIZE; //防止连续3次触发下行 hit+1
                if(ballCount > 0)
                    ballCount <= ballCount - 1;
            end
        end
     end               
        
     assign ball_x_r = ball_x_l + BALL_SIZE - 1; 
     assign ball_y_b = ball_y_t + BALL_SIZE - 1;
     
    logic [2:0] rom_addr, rom_col; // ROM中8行、8列
    logic rom_bit;                 // ROM中每个像素值
    logic [7:0] rom_data;
        
    always_comb       // round ball image ROM 
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
    assign ball_g = 4'b0000; 
    assign ball_b = 4'b0000;    
    
    // Fudan picture
    logic [10:0] C1, R1; //图片左上角坐标（C1, R1）
    assign C1 = (MAX_X - 320) / 2; //水平居中=160
    assign R1 = (MAX_Y - 320) / 2; //垂直居中=80
    
    logic [10:0] xPic, yPic; //图片内坐标
    assign xPic =  pix_x - H_SYNC_START - C1;
    assign yPic =  pix_y - V_SYNC_START - R1;
    
    // read picture data from ROM
    assign picAddr17 = 320 * yPic + xPic;
    
    assign picOn = ((pix_x > H_SYNC_START+C1)     &&
                    (pix_x < H_SYNC_START+C1+320) &&
                    (pix_y > V_SYNC_START+R1)     && 
                    (pix_y < V_SYNC_START+R1+320));
    assign pic_r = picData[11:8]; // 4bits red 
    assign pic_g = picData[7:4];  // 4bits green
    assign pic_b = picData[3:0];  // 4bits blue  
    
    // (Text) 得分文字: 16x8点阵 "Score:??"  
    logic [10:0] C2, R2; //图片左上角坐标（C2, R2）
    assign C2 = 200;
    assign R2 = 10;
    
    logic [10:0] xText, yText; //Text内坐标
    assign xText =  pix_x - H_SYNC_START - C2 - 1;
    assign yText =  pix_y - V_SYNC_START - R2 - 1;
    
    logic [10:0] txtAddr; //{charAddr, rowAddr}
    logic [6:0] charAddr; //字符地址
    logic [3:0] rowAddr;  //行地址
    logic [0:7] textData; //字符ROM顺序从小到大!!
    logic One_bit;    //每个字符一行中的每1位数据
    
    always @(*)
        case (xText[8:4])    // xText[3:0]为1个字
            4'h0: charAddr = 7'h53; // S
            4'h1: charAddr = 7'h63; // c
            4'h2: charAddr = 7'h6f; // o
            4'h3: charAddr = 7'h72; // r
            4'h4: charAddr = 7'h65; // e
            4'h5: charAddr = 7'h3a; // :
            4'h6: charAddr = {3'b011, textBalls1}; // 十位数
            4'h7: charAddr = {3'b011, textBalls0}; // 个位数
            4'h8: charAddr = 7'h20;
            4'h9: charAddr = 7'h42; // B
            4'ha: charAddr = 7'h61; // a
            4'hb: charAddr = 7'h6c; // l
            4'hc: charAddr = 7'h6c; // l
            4'hd: charAddr = 7'h73; // s
            4'he: charAddr = 7'h3a; // :
            4'hf: charAddr = 'h30 + ballCount; // 个位数
            default:charAddr=7'hXX;
        endcase
       
    assign rowAddr = yText[4:1];  // 每个字共16行
    assign txtAddr = {charAddr, rowAddr};
    
    // 从ROM中获取字符每行8位数据textData
    ASCII_ROM A1(.a(txtAddr), .spo(textData));
    
    // 提取出每个字符一行中的每1位数据
    assign One_bit = textData[xText[3:1]];

    // 32x16点阵 "Score:??"  
    assign textOn = ((pix_x > H_SYNC_START+C2)       &&
                     (pix_x < H_SYNC_START+C2+8*16*2) && //8字符*8bits*2
                     (pix_y > V_SYNC_START+R2)       && 
                     (pix_y < V_SYNC_START+R2+16*2)) && //16bits高 * 2
                     One_bit ;  // 像素=1？
                                    
    // Show red "Game Over" in the middle of screen
    logic [10:0] C3, R3; //图片左上角坐标（C3, R3）
    assign C3 = 200;
    assign R3 = 200;

    logic [10:0] xText2, yText2; //Text内坐标
    assign xText2 =  pix_x - H_SYNC_START - C3 - 1;
    assign yText2 =  pix_y - V_SYNC_START - R3 - 1;

    logic [10:0] txtAddr2; //{charAddr, rowAddr}
    logic [6:0] charAddr2; //字符地址
    logic [3:0] rowAddr2;  //行地址
    logic [0:7] textData2; //字符ROM顺序从小到大!!
    logic One_bit2;    //每个字符一行中的每1位数据

    always @(*)
        case (xText2[8:4])    // xText[3:0]为1个字
            4'h0: charAddr2 = 7'h47; // G
            4'h1: charAddr2 = 7'h61; // a
            4'h2: charAddr2 = 7'h6d; // m
            4'h3: charAddr2 = 7'h65; // e
            4'h4: charAddr2 = 7'h20; // 
            4'h5: charAddr2 = 7'h4f; // O
            4'h6: charAddr2 = 7'h76; // v
            4'h7: charAddr2 = 7'h65; // e
            4'h8: charAddr2 = 7'h72; // r
            4'h9: charAddr2 = 7'h20; // 
            4'ha: charAddr2 = 7'h21; // !
            default:charAddr2=7'hXX;
        endcase

    assign rowAddr2 = yText2[4:1];  // 每个字共16行
    assign txtAddr2 = {charAddr2, rowAddr2};

    // 从ROM中获取字符每行8位数据textData
    ASCII_ROM A2(.a(txtAddr2), .spo(textData2));

    // 提取出每个字符一行中的每1位数据
    assign One_bit2 = textData2[xText2[3:1]];

    // 32x16点阵 "Game Over"
    logic textOn2;
    assign textOn2 = ((pix_x > H_SYNC_START+C3)       &&
                     (pix_x < H_SYNC_START+C3+8*11*2) && //8字符*8bits*2
                     (pix_y > V_SYNC_START+R3)       && 
                     (pix_y < V_SYNC_START+R3+16*2)) && //16bits高 * 2
                     One_bit2 ;  // 像素=1？

    always_comb   // ===== rgb 输出 ======
        if (~videoOn) 
        begin
            red   = 4'b0000; // blank
            green = 4'b0000; // blank
            blue  = 4'b0000; // blank
        end
        else if (ballCount == 0 && textOn2)
        begin
            red   = 4'b1111; // red
            green = 4'b0000; // red
            blue  = 4'b0000; // red
        end
        else if (wallOn)
        begin
            red   = wall_r;
            green = wall_g; 
            blue  = wall_b; 
        end
        else if (ballOn && ballCount != 0)
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
        else if (picOn)
        begin
            red   = pic_r;
            green = pic_g;
            blue  = pic_b;
        end
        else if (textOn) 
        begin  // black
            red   = 4'b0000;
            green = 4'b0000; 
            blue  = 4'b0000;
        end 
        else
        begin // gray background
            red   = 4'b1110; 
            green = 4'b1110; 
            blue  = 4'b1110; 
        end
endmodule
