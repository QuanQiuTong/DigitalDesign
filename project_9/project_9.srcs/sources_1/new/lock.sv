module lock(
    input       clk, clr,
    input [1:0] btn,
    input [7:0] key,
    output      pass,
    output logic [4:0] sta
    );
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4,
                      E1 = 5, E2 = 6, E3 = 7, E4 = 8;
    
    reg [4:0] state, next_state;
    reg [3:0] cnt;

    always_comb
        case (state)
            S0: if(btn == key[7:6] && cnt == 0)begin next_state = S1; cnt <= 1; end
                else if(btn != key[7:6] && cnt == 0)begin next_state = E1; cnt <= 1; end
                else next_state = S0;
            S1: if(btn == key[5:4] && cnt == 1)begin next_state = S2; cnt <= 2; end
                else if(btn != key[5:4] && cnt == 1)begin next_state = E2; cnt <= 2; end
                else next_state = S1;
            S2: if(btn == key[3:2] && cnt == 2)begin next_state = S3; cnt <= 3; end
                else if(btn != key[3:2] && cnt == 2)begin next_state = E3; cnt <= 3; end
                else next_state = S2;
            S3: if(btn == key[1:0] && cnt == 3)begin next_state = S4; cnt <= 4; end
                else if(btn != key[1:0] && cnt == 3)begin next_state = E4; cnt <= 4; end
                else next_state = S3;
            S4: if(btn == key[1:0] && cnt == 4)begin next_state = S4; cnt <= 4; end
                else if(btn != key[1:0] && cnt == 4)begin next_state = E4; cnt <= 4; end
                else next_state = S4;
            E1: if(btn == key[7:6] && cnt == 1)begin next_state = S1; cnt <= 1; end
                else if(btn != key[7:6] && cnt == 1)begin next_state = E1; cnt <= 1; end
                else next_state = S0;
            default: next_state = S0;
        endcase
    
    always_ff @(posedge clk, posedge clr)
        if(clr) begin state <= S0; cnt <= 0; end
        else state <= next_state;
    
    assign pass = (state == S4);
    assign sta = state;
endmodule
