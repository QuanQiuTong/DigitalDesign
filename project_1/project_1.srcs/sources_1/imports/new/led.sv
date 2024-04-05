`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/04 12:26:43
// Design Name: 
// Module Name: led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led (
    input logic [15:0] SW,
    output logic [15:0] LED
);
    assign LED[0] = SW[0];
    assign LED[15] = SW[15];
    assign LED[8] = SW[0] & SW[15];
endmodule

