module music(              // ��������
    input  logic clk,
    output logic audioData,// Open-drain output
    output logic audioSD); // Analog filter ShutDown input  
    
    assign audioSD = 1;   // һֱ����
           
    localparam MEM_SIZE = 106353; //���ݳ���    
    logic [16:0] address; // 2^17=131,072 > 106,353     
    logic [7:0] value;    // ��Ƶ����(8λ:0-255)
    logic clk2048kHz;     // 1k=1000
    
    clk2MHz C2(clk, clk2048kHz);
    
    SuperMario M1(.clka(clk),     // ��ͬ��
                  .addra(address),// input [16:0]
                  .douta(value) );// output -8λ���� 

    logic [7:0] counter = 0; 
    // 8kHz * 256 steps = 2,048kHz
    always @(posedge clk2048kHz) 
    begin
        counter <= counter + 1;
        
        //��counter<valueʱ��AUD_PWM=1; ���� =0.
        audioData <= (counter < value); 
      
        if (counter == (256 - 1))    // 8kHz
        begin
            // ÿ8kHz,ȥROM��ȡһ����Ƶ����
            address <= address + 1;  
            // �ظ����ţ���ַ��0
            if (address == MEM_SIZE) address <= 0;
        end
    end
endmodule

module clk2MHz(
    input  logic clk,
    output logic clk2MHz);
    
    //input = 100MHz
    localparam CNT_MAX = 50; // 100MHz / 2MHz = 50
    
    logic [5:0] cnt;

    always_ff @(posedge clk)
    begin
        if (cnt == CNT_MAX-1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    assign clk2MHz = (cnt == CNT_MAX-1);

endmodule
