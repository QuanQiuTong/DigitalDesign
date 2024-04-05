`timescale 1ns / 1ps

module top(
    input  logic        CLK100MHZ,
    input  logic [15:0] SW,
    output logic [15:0] LED,
    output logic [6:0]  A2G,
    output logic [7:0]  AN,
    output logic        DP
);
    logic [3:0] f;
    logic c_out;

    ALU alu(
        .a(SW[3:0]), 
        .b(SW[7:4]), 
        .c_in(SW[8]), 
        .s(SW[14:13]), 
        .m(SW[15]), 
        .f(f), 
        .c_out(c_out)
    );
    
    logic [39:0] disp;
    assign disp[4:0] = f;
    assign disp[14:10] = 17;
    assign disp[39:35] = SW[3:0];
    always_comb
        if(SW[13]||SW[14]||SW[15])
            disp[29:25] = SW[7:4];
        else 
            disp[29:25] = 31;
        
    always_comb
        case({SW[15],SW[13]})
            'b10: begin
                disp[9:5] = c_out;
                disp[19:15] = SW[8];
                disp[24:20] = 16;
                disp[34:30] = 16;
            end 
            'b11: begin
                disp[9:5] = c_out;
                disp[19:15] = SW[8];
                disp[24:20] = 18;
                disp[34:30] = 18;
            end
            default: begin
                disp[9:5] = 31;
                disp[19:15] = 31;
                disp[24:20] = 31;
                disp[34:30] = 31;
            end
        endcase

    x7seg x7(disp, CLK100MHZ, A2G, AN, DP);
    assign LED = SW;
endmodule
