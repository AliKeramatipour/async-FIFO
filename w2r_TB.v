`timescale 1 ns / 1 ps
module w2r_TB();
      parameter ADDRSIZE = 4;
      wire [ADDRSIZE:0] _2nd_reg;
      reg [ADDRSIZE:0] graycode_rptr;
      reg clk = 0;
      reg rst;

      w2r #(ADDRSIZE) UUT(_2nd_reg, graycode_rptr, clk, rst);
      always #50 clk = ~clk ;
      initial begin
        rst = 1 ;    
        #100 
        rst = 0;
        #100
        graycode_rptr = 'd100;
        #100
        graycode_rptr = 'd200;
        #100
        graycode_rptr = 'd300;
        #100
        graycode_rptr = 'd400;
        #100
        graycode_rptr = 'd500;
        #200
        $stop;
      end
endmodule