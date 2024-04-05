module pingpong_screen_textBig(
    input  logic clk, reset,          //clk: ��Ļ60Hzˢ��Ƶ��
    input  logic btnUp, btnDown,      //����Bar�����ƶ�
    input  logic videoOn,
    input  logic [10:0] pix_x, pix_y, //��Ļ����
    output logic [3:0]  red, green, blue, 
    input  logic [11:0] picData,   //ÿ��������12λ��ʾɫ��
    output logic [16:0] picAddr17);//320x320=102,400bit.(2^17=131,072) 
     
    localparam 
      MAX_X = 640,  MAX_Y = 480,  //(0.0) to (640-1,480-1)
      // ��Ļ����
      H_SYNC    =  96,           // horizontal sync width
      H_BACK    =  48,           // left border (back porch) 
      H_SYNC_START = H_SYNC + H_BACK, //����ʾ���� = 144(96+48)
      V_SYNC    =   2,           // vertical sync lines
      V_TOP     =  29,           // vertical top border  
      V_SYNC_START = V_SYNC + V_TOP, //����ʾ���� =  31(2+29)   
      // === wall === 
      WALL_X_L = H_SYNC_START + 30, // left boundary
      WALL_X_R = H_SYNC_START + 40, // right boundary  
      // === bar === 
      BAR_X_L = H_SYNC_START + 600, // left boundary
      BAR_X_R = H_SYNC_START + 605, // right boundary   
      BAR_Y_SIZE = 70,              // bar �ĸ߶�
      BAR_Y_T = V_SYNC_START + MAX_Y/2 - BAR_Y_SIZE/2, //Top=204 
      BAR_Y_B = BAR_Y_T + BAR_Y_SIZE -1, // bottom boundary 
      BAR_V = 4,                    // ÿ���ƶ� bar �ľ���  
      // === ball ===
      BALL_SIZE = 8, 
      BALL_X_L = H_SYNC_START + 580,       // left boundary 
      BALL_X_R = BALL_X_L + BALL_SIZE - 1, // right boundary 
      BALL_Y_T = V_SYNC_START + MAX_Y/2 -BALL_SIZE/2,//top boundary 
      BALL_Y_B = BALL_Y_T + BALL_SIZE - 1,       // bottom boundary 
      BALL_V = 2;                          // ÿ���ƶ� ball �ľ���
         
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
                    (bar_y_t<=pix_y) && (pix_y<=bar_y_b)); //����
    assign bar_r = 4'b0000; 
    assign bar_g = 4'b1111; // green
    assign bar_b = 4'b0000; 

    // ��round ball��    
    logic [10:0] ball_x_l, ball_x_r; // ball left, right boundary
    logic [10:0] ball_y_t, ball_y_b; // ball top, bottom boundary
    logic [10:0] ball_dx , ball_dy ; // ball x, y ���� 
    logic [3:0] textBalls0, textBalls1; // �÷ָ�λ,ʮλ
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
            textBalls0 <= 4'b0000;   //�÷ָ�λ
            textBalls1 <= 4'b0000;   //�÷�ʮλ
            ballCount <= 5;
        end
        else   begin
            ball_x_l <= ball_x_l + ball_dx;  // С��clk����һֱ�������ƶ�
            ball_y_t <= ball_y_t + ball_dy;  // С��clk����һֱ�������ƶ�
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
                ball_x_l <= BAR_X_L - BALL_SIZE;//��ֹ����3�δ������� hit+1      
                textBalls0 <= textBalls0 + 1;   //��16����+1            
            end
            else if (ball_x_r >= H_SYNC_START + MAX_X) //reach right screen
            begin
                ball_dx <= -1 * BALL_V;             
                ball_x_l <= H_SYNC_START + MAX_X - BALL_SIZE; //��ֹ����3�δ������� hit+1
                if(ballCount > 0)
                    ballCount <= ballCount - 1;
            end
        end
     end               
        
     assign ball_x_r = ball_x_l + BALL_SIZE - 1; 
     assign ball_y_b = ball_y_t + BALL_SIZE - 1;
     
    logic [2:0] rom_addr, rom_col; // ROM��8�С�8��
    logic rom_bit;                 // ROM��ÿ������ֵ
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
    
    assign rom_col  = pix_x[2:0] - ball_x_l[2:0]; // ROM��
    assign rom_addr = pix_y[2:0] - ball_y_t[2:0]; // ROM��
    assign rom_bit  = rom_data[rom_col]; //ROMaddr����col��ֵ  
         
    // pixel within ball
    assign ballOn = ((ball_x_l<=pix_x) && (pix_x<=ball_x_r) &&  //����
                     (ball_y_t<=pix_y) && (pix_y<=ball_y_b)) &  //���� 
                     rom_bit;  // round ball
    assign ball_r = 4'b1111; // red
    assign ball_g = 4'b0000; 
    assign ball_b = 4'b0000;    
    
    // Fudan picture
    logic [10:0] C1, R1; //ͼƬ���Ͻ����꣨C1, R1��
    assign C1 = (MAX_X - 320) / 2; //ˮƽ����=160
    assign R1 = (MAX_Y - 320) / 2; //��ֱ����=80
    
    logic [10:0] xPic, yPic; //ͼƬ������
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
    
    // (Text) �÷�����: 16x8���� "Score:??"  
    logic [10:0] C2, R2; //ͼƬ���Ͻ����꣨C2, R2��
    assign C2 = 200;
    assign R2 = 10;
    
    logic [10:0] xText, yText; //Text������
    assign xText =  pix_x - H_SYNC_START - C2 - 1;
    assign yText =  pix_y - V_SYNC_START - R2 - 1;
    
    logic [10:0] txtAddr; //{charAddr, rowAddr}
    logic [6:0] charAddr; //�ַ���ַ
    logic [3:0] rowAddr;  //�е�ַ
    logic [0:7] textData; //�ַ�ROM˳���С����!!
    logic One_bit;    //ÿ���ַ�һ���е�ÿ1λ����
    
    always @(*)
        case (xText[8:4])    // xText[3:0]Ϊ1����
            4'h0: charAddr = 7'h53; // S
            4'h1: charAddr = 7'h63; // c
            4'h2: charAddr = 7'h6f; // o
            4'h3: charAddr = 7'h72; // r
            4'h4: charAddr = 7'h65; // e
            4'h5: charAddr = 7'h3a; // :
            4'h6: charAddr = {3'b011, textBalls1}; // ʮλ��
            4'h7: charAddr = {3'b011, textBalls0}; // ��λ��
            4'h8: charAddr = 7'h20;
            4'h9: charAddr = 7'h42; // B
            4'ha: charAddr = 7'h61; // a
            4'hb: charAddr = 7'h6c; // l
            4'hc: charAddr = 7'h6c; // l
            4'hd: charAddr = 7'h73; // s
            4'he: charAddr = 7'h3a; // :
            4'hf: charAddr = 'h30 + ballCount; // ��λ��
            default:charAddr=7'hXX;
        endcase
       
    assign rowAddr = yText[4:1];  // ÿ���ֹ�16��
    assign txtAddr = {charAddr, rowAddr};
    
    // ��ROM�л�ȡ�ַ�ÿ��8λ����textData
    ASCII_ROM A1(.a(txtAddr), .spo(textData));
    
    // ��ȡ��ÿ���ַ�һ���е�ÿ1λ����
    assign One_bit = textData[xText[3:1]];

    // 32x16���� "Score:??"  
    assign textOn = ((pix_x > H_SYNC_START+C2)       &&
                     (pix_x < H_SYNC_START+C2+8*16*2) && //8�ַ�*8bits*2
                     (pix_y > V_SYNC_START+R2)       && 
                     (pix_y < V_SYNC_START+R2+16*2)) && //16bits�� * 2
                     One_bit ;  // ����=1��
                                    
    // Show red "Game Over" in the middle of screen
    logic [10:0] C3, R3; //ͼƬ���Ͻ����꣨C3, R3��
    assign C3 = 200;
    assign R3 = 200;

    logic [10:0] xText2, yText2; //Text������
    assign xText2 =  pix_x - H_SYNC_START - C3 - 1;
    assign yText2 =  pix_y - V_SYNC_START - R3 - 1;

    logic [10:0] txtAddr2; //{charAddr, rowAddr}
    logic [6:0] charAddr2; //�ַ���ַ
    logic [3:0] rowAddr2;  //�е�ַ
    logic [0:7] textData2; //�ַ�ROM˳���С����!!
    logic One_bit2;    //ÿ���ַ�һ���е�ÿ1λ����

    always @(*)
        case (xText2[8:4])    // xText[3:0]Ϊ1����
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

    assign rowAddr2 = yText2[4:1];  // ÿ���ֹ�16��
    assign txtAddr2 = {charAddr2, rowAddr2};

    // ��ROM�л�ȡ�ַ�ÿ��8λ����textData
    ASCII_ROM A2(.a(txtAddr2), .spo(textData2));

    // ��ȡ��ÿ���ַ�һ���е�ÿ1λ����
    assign One_bit2 = textData2[xText2[3:1]];

    // 32x16���� "Game Over"
    logic textOn2;
    assign textOn2 = ((pix_x > H_SYNC_START+C3)       &&
                     (pix_x < H_SYNC_START+C3+8*11*2) && //8�ַ�*8bits*2
                     (pix_y > V_SYNC_START+R3)       && 
                     (pix_y < V_SYNC_START+R3+16*2)) && //16bits�� * 2
                     One_bit2 ;  // ����=1��

    always_comb   // ===== rgb ��� ======
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
