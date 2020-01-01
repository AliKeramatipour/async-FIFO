`timescale 1 ns / 1 ps
module fifomem_TB #(parameter WORDSIZE = 8,
                parameter ADDRSIZE = 8)
              (input [ADDRSIZE-1:0] waddr, raddr
               input [WORDSIZE-1:0] rdata,
               output[WORDSIZE-1:0] wdata,
               input wfull, wclk, wclken );

               reg [WORDSIZE-1:0] mem [0:ADDRSIZE-1];

               assign rdata = mem[raddr];
               always @(posedge wclk) begin
                mem[waddr] <= wdata;
               end
endmodule