module Bin2BCD(
    input  logic [7:0] bin,
    output logic [9:0] bcd
    );
    logic [17:0] z;
    integer  i;

    always_comb begin
        for(i = 0; i != 18; i += 1)
            z[i] = 0;
        
        z[10:3] = bin;

        repeat(5) begin
            if(z[11:8] >= 5)
                z[11:8] += 3;
            if(z[15:12] >= 5)
                z[15:12] += 3;
            z[17:1] = z[16:0];
        end
        bcd = z[17:8];
    end
endmodule
