module pingpong_hitting_bricks(
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
      WALL_X_L1 = H_SYNC_START + 30, // left boundary
      WALL_X_R1 = H_SYNC_START + 40, // right boundary
      WALL_X_L2 = H_SYNC_START + 50, // left boundary
      WALL_X_R2 = H_SYNC_START + 60, // right boundary
      WALL_X_L3 = H_SYNC_START + 70, // left boundary
      WALL_X_R3 = H_SYNC_START + 80, // right boundary
      WALL_Y_T1 = V_SYNC_START, // top boundary
      WALL_Y_B1 = V_SYNC_START + 105, // bottom boundary
      WALL_Y_T2 = V_SYNC_START + 125, // top boundary
      WALL_Y_B2 = V_SYNC_START + 230, // bottom boundary
      WALL_Y_T3 = V_SYNC_START + 250, // top boundary
      WALL_Y_B3 = V_SYNC_START + 355, // bottom boundary
      WALL_Y_T4 = V_SYNC_START + 375, // top boundary
      WALL_Y_B4 = V_SYNC_START + 480, // bottom boundary
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

    // Signals

    logic ballOn, wallOn, barOn;
    logic [3:0] wall_r, wall_g, wall_b;
    logic [3:0] ball_r, ball_g, ball_b;
    logic [3:0] bar_r, bar_g, bar_b;

    logic [11:0] wall;
    initial begin
        wall = 12'b1111_1111_1111;
    end

    assign wallOn = ((WALL_X_L1 <= pix_x) && (pix_x <= WALL_X_R1) &&
                    (WALL_Y_T1 <= pix_y) && (pix_y <= WALL_Y_B1) && wall[0]) ||
                   ((WALL_X_L2 <= pix_x) && (pix_x <= WALL_X_R2) &&
                    (WALL_Y_T1 <= pix_y) && (pix_y <= WALL_Y_B1) && wall[1]) ||
                   ((WALL_X_L3 <= pix_x) && (pix_x <= WALL_X_R3) &&
                    (WALL_Y_T1 <= pix_y) && (pix_y <= WALL_Y_B1) && wall[2]) ||
                   ((WALL_X_L1 <= pix_x) && (pix_x <= WALL_X_R1) &&
                    (WALL_Y_T2 <= pix_y) && (pix_y <= WALL_Y_B2) && wall[3]) ||
                   ((WALL_X_L2 <= pix_x) && (pix_x <= WALL_X_R2) &&
                    (WALL_Y_T2 <= pix_y) && (pix_y <= WALL_Y_B2) && wall[4]) ||
                   ((WALL_X_L3 <= pix_x) && (pix_x <= WALL_X_R3) &&
                    (WALL_Y_T2 <= pix_y) && (pix_y <= WALL_Y_B2) && wall[5]) ||
                   ((WALL_X_L1 <= pix_x) && (pix_x <= WALL_X_R1) &&
                    (WALL_Y_T3 <= pix_y) && (pix_y <= WALL_Y_B3) && wall[6]) ||
                     ((WALL_X_L2 <= pix_x) && (pix_x <= WALL_X_R2) &&
                    (WALL_Y_T3 <= pix_y) && (pix_y <= WALL_Y_B3) && wall[7]) ||
                     ((WALL_X_L3 <= pix_x) && (pix_x <= WALL_X_R3) &&
                    (WALL_Y_T3 <= pix_y) && (pix_y <= WALL_Y_B3) && wall[8]) ||
                     ((WALL_X_L1 <= pix_x) && (pix_x <= WALL_X_R1) &&
                    (WALL_Y_T4 <= pix_y) && (pix_y <= WALL_Y_B4) && wall[9]) ||
                     ((WALL_X_L2 <= pix_x) && (pix_x <= WALL_X_R2) &&
                    (WALL_Y_T4 <= pix_y) && (pix_y <= WALL_Y_B4) && wall[10]) ||
                     ((WALL_X_L3 <= pix_x) && (pix_x <= WALL_X_R3) &&
                    (WALL_Y_T4 <= pix_y) && (pix_y <= WALL_Y_B4) && wall[11]);
    assign wall_r = 4'b0000;
    assign wall_g = 4'b0000;
    assign wall_b = 4'b1111; // blue

    logic [10:0] bar_y_t, bar_y_b; // bar top, bottom boundary
    // new bar y-position
    always @(posedge clk, posedge reset) begin
        if (reset)
            bar_y_t <= BAR_Y_T;
        else if (btnDown & (bar_y_b <= (V_SYNC_START + MAX_Y - 1 - BAR_V)))
                bar_y_t <= bar_y_t + BAR_V; // move down
        else if (btnUp & (bar_y_t >= (V_SYNC_START + BAR_V)))
                bar_y_t <= bar_y_t - BAR_V; // move up
    end

    assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1;

    assign barOn = ((BAR_X_L <= pix_x) && (pix_x <= BAR_X_R) &&
                    (bar_y_t <= pix_y) && (pix_y <= bar_y_b)); //变量
    assign bar_r = 4'b0000;
    assign bar_g = 4'b1111; // green
    assign bar_b = 4'b0000;

    logic [10:0] ball_x_l, ball_y_t, ball_dx, ball_dy, ball_x_r, ball_y_b;
    // Ball movement and collision detection
    always @(posedge clk, posedge reset)
        if (reset) begin
            ball_x_l <= BALL_X_L;
            ball_y_t <= BALL_Y_T;
            ball_dx  <= -1 * BALL_V;
            ball_dy  <= -1 * BALL_V;
            wall <= 12'b1111_1111_1111;
        end else begin
            ball_x_l <= ball_x_l + ball_dx;
            ball_y_t <= ball_y_t + ball_dy;

            // Ball bounce back
            if (ball_y_t <= V_SYNC_START)              //reach top screen
                ball_dy <= BALL_V;
            else if (ball_y_b >= V_SYNC_START + MAX_Y) //reach bottom screen 
                ball_dy <= -1 * BALL_V;                                     
            else if ((ball_x_r >= BAR_X_L) &&          //reach right bar
                     (ball_x_r <= BAR_X_R) &&   
                     (ball_y_b >= bar_y_t) &&  (ball_y_t <= bar_y_b))
                ball_dx <= -1 * BALL_V;                             
            else if (ball_x_r >= H_SYNC_START + MAX_X - 1) //reach right screen
                ball_dx <= -1 * BALL_V;       
            else if (ball_x_l <= H_SYNC_START)             //reach left screen
                ball_dx <= BALL_V;      
            else if((ball_x_l <= WALL_X_R1) && (ball_x_r >= WALL_X_L1) &&
                    (ball_y_t <= WALL_Y_B1) && (ball_y_b >= WALL_Y_T1) && wall[0]) begin
                wall[0] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R2) && (ball_x_r >= WALL_X_L2) &&
                        (ball_y_t <= WALL_Y_B1) && (ball_y_b >= WALL_Y_T1) && wall[1]) begin
                wall[1] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R3) && (ball_x_r >= WALL_X_L3) &&
                        (ball_y_t <= WALL_Y_B1) && (ball_y_b >= WALL_Y_T1) && wall[2]) begin
                wall[2] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R1) && (ball_x_r >= WALL_X_L1) &&
                        (ball_y_t <= WALL_Y_B2) && (ball_y_b >= WALL_Y_T2) && wall[3]) begin
                wall[3] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R2) && (ball_x_r >= WALL_X_L2) &&
                        (ball_y_t <= WALL_Y_B2) && (ball_y_b >= WALL_Y_T2) && wall[4]) begin
                wall[4] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R3) && (ball_x_r >= WALL_X_L3) &&
                        (ball_y_t <= WALL_Y_B2) && (ball_y_b >= WALL_Y_T2) && wall[5]) begin
                wall[5] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R1) && (ball_x_r >= WALL_X_L1) &&
                        (ball_y_t <= WALL_Y_B3) && (ball_y_b >= WALL_Y_T3) && wall[6]) begin
                wall[6] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R2) && (ball_x_r >= WALL_X_L2) &&
                        (ball_y_t <= WALL_Y_B3) && (ball_y_b >= WALL_Y_T3) && wall[7]) begin
                wall[7] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R3) && (ball_x_r >= WALL_X_L3) &&
                        (ball_y_t <= WALL_Y_B3) && (ball_y_b >= WALL_Y_T3) && wall[8]) begin
                wall[8] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R1) && (ball_x_r >= WALL_X_L1) &&
                        (ball_y_t <= WALL_Y_B4) && (ball_y_b >= WALL_Y_T4) && wall[9]) begin
                wall[9] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R2) && (ball_x_r >= WALL_X_L2) &&
                        (ball_y_t <= WALL_Y_B4) && (ball_y_b >= WALL_Y_T4) && wall[10]) begin
                wall[10] <= 0;
                ball_dx <= BALL_V;
            end else if((ball_x_l <= WALL_X_R3) && (ball_x_r >= WALL_X_L3) &&
                        (ball_y_t <= WALL_Y_B4) && (ball_y_b >= WALL_Y_T4) && wall[11]) begin
                wall[11] <= 0;
                ball_dx <= BALL_V;
            end
        end

    // Calculate ball right and bottom coordinates
    assign ball_x_r = ball_x_l + BALL_SIZE - 1; 
    assign ball_y_b = ball_y_t + BALL_SIZE - 1;


    logic [2:0] rom_addr, rom_col;
    logic rom_bit;
    logic [7:0] rom_data;
    always_comb // Image ROM
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

    assign ballOn = ((ball_x_l <= pix_x) && (pix_x <= ball_x_r) &&
                     (ball_y_t <= pix_y) && (pix_y <= ball_y_b)) &
                     rom_bit;
    assign ball_r = 4'b1111; // red
    assign ball_g = 4'b0000;
    assign ball_b = 4'b0000;

    // RGB output
    always_comb begin
        if (~videoOn) begin
            red   = 4'b0000; // blank
            green = 4'b0000; // blank
            blue  = 4'b0000; // blank
        end else if (wallOn) begin
            red   = wall_r;
            green = wall_g; 
            blue  = wall_b; 
        end else if (ballOn) begin
            red   = ball_r;
            green = ball_g;
            blue  = ball_b;
        end else if (barOn) begin
            red   = bar_r;
            green = bar_g;
            blue  = bar_b;
        end else begin // gray background
            red   = 4'b1110; 
            green = 4'b1110; 
            blue  = 4'b1110; 
        end
    end
endmodule
