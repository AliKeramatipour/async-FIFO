`timescale 1 ns / 1 ps
module r2w #(parameter ADDRSIZE = 4)
            (output reg [ADDRSIZE:0] _2nd_reg,
            input       [ADDRSIZE:0] rptr,
            input                    wclk, rst );
    reg [ADDRSIZE:0] _1st_reg;
    always @(posedge wclk or posedge rst)
    begin
        if ( rst )  {_2nd_reg,_1st_reg} <= 0;
        else        {_2nd_reg,_1st_reg} <= {_1st_reg,rptr}
    end
endmodule