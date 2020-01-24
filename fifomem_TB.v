`timescale 1 ns / 1 ps
module fifomem_TB();
      parameter WORDSIZE = 8;
      parameter ADDRSIZE = 3;
      reg [ADDRSIZE-1:0] waddr = 0, raddr = 0;
      reg [WORDSIZE-1:0] wdata = 0;
      reg full = 0;
      reg clk = 0;
      fifomem #(WORDSIZE,ADDRSIZE) UUT(waddr, raddr, rdata , wdata, full, clk);
     always #100 clk = ~clk;
     initial begin
       #50  wdata = 3'd100;
            waddr = 3'b000;
       #150 wdata = 3'd101;
            waddr = 3'b001;
       #250 wdata = 3'd101;
            waddr = 3'b010;
       #350 wdata = 3'd102;
            waddr = 3'b011;
       #450 wdata = 3'd103;
            waddr = 3'b100;
       #550 wdata = 3'd104;
            waddr = 3'b101;
       #650 wdata = 3'd105;
            waddr = 3'b110;
       #750 wdata = 3'd106;
            waddr = 3'b111;
     end
     
endmodule