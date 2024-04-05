module _74LS161A (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire load,
    input wire up_down,
    input wire [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            q <= 4'b0;
        end else if (en) begin
            if (load) begin
                q <= d;
            end else if (up_down) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule

module _74LS161(
    input Clk, Clr_n, LD_n, P, T,
    input [3:0] D,
    output reg [3:0] Q,
    output CO
    );
    always_ff @( posedge Clk, negedge Clr_n )
        if ( ~Clr_n ) Q <= 4'b0;
        else if ( ~LD_n ) Q <= D;
        else if ( P & T ) Q <= Q + 1;
        
    assign CO = (&Q) & T;
endmodule

module _74LS163(
    input Clk, Clr_n, LD_n, P, T,
    input [3:0] D,
    output reg [3:0] Q,
    output CO
    );
    always_ff @( posedge Clk )
        if ( ~Clr_n ) Q <= 4'b0;
        else if ( ~LD_n ) Q <= D;
        else if ( P & T ) Q <= Q + 1;
        
    assign CO = (&Q) & T;
endmodule