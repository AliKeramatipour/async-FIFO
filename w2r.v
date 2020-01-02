`timescale 1 ns / 1 ps
module w2r #(parameter ADDRSIZE = 4)
            (output reg [ADDRSIZE:0] _2nd_reg,
            input       [ADDRSIZE:0] graycode_wptr,
            input                    rclk, rst );
    reg [ADDRSIZE:0] _1st_reg;
    always @(posedge rclk or posedge rst)
    begin
        if ( rst )  {_2nd_reg,_1st_reg} <= 0;
        else        {_2nd_reg,_1st_reg} <= {_1st_reg,graycode_wptr};
    end
endmodule