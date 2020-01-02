`timescale 1 ns / 1 ps
module fifomem #(parameter WORDSIZE = 8,
                parameter ADDRSIZE = 8)
              (input [ADDRSIZE-1:0] waddr, raddr,
               output[WORDSIZE-1:0] rdata,
               input [WORDSIZE-1:0] wdata,
               input full, wclk);

               reg [WORDSIZE-1:0] mem [0:ADDRSIZE-1];

               assign rdata = mem[raddr];
               always @(posedge wclk) begin
                if ( !full )
                  mem[waddr] <= wdata;
               end
endmodule