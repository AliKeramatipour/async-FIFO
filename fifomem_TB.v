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
          #50  wdata =  'd100;
               waddr = 3'b000;
               
          #150 wdata =  'd101;
               waddr = 3'b001;
               
          #250 wdata =  'd102;
               waddr = 3'b010;
               
          #350 wdata =  'd103;
               waddr = 3'b011;
               
          #450 wdata =  'd104;
               waddr = 3'b100;
               
          #550 wdata =  'd105;
               waddr = 3'b101;
               
          #650 wdata =  'd106;
               waddr = 3'b110;
               
          #750 wdata =  'd107;
               waddr = 3'b111;
               
          #850 raddr = 3'b010;
          #950 raddr = 3'b011;
          #1050 raddr = 3'b100;
       $stop;
     end
     
endmodule