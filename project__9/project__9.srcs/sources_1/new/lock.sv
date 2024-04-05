module lock(
    input       clk, clr,
    input [1:0] Din,
    input [7:0] key,
    output      pass, fail
    );
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4,
                      E1 = 5, E2 = 6, E3 = 7, E4 = 8;
    
    reg [4:0] state;

    always_ff @(posedge clk, posedge clr)
        if (clr) state <= S0;
        else case (state)
            S0: if(Din == key[7:6])state<= S1; else state<= E1;
            S1: if(Din == key[5:4])state<= S2; else state<= E2;
            S2: if(Din == key[3:2])state<= S3; else state<= E3;
            S3: if(Din == key[1:0])state<= S4; else state<= E4;
            S4: if(Din == key[7:6])state<= S1; else state<= E1;
            
            E1: state <= E2;
            E2: state <= E3;
            E3: state <= E4;
            E4: if(Din == key[7:6])state<= S1; else state<= E1;

            default: state<= S0;
        endcase
    
    assign pass = (state == S4);
    assign fail = (state == E4);
endmodule
