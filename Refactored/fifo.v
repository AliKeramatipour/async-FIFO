module fifo #(parameter DSIZE = 8,
parameter ASIZE = 3)
(output [DSIZE-1:0] rdata,
output wfull,
output rempty,
input [DSIZE-1:0] wdata,
input winc, wclk, wrst_n,
input rinc, rclk, rrst_n);

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    r2w r2w (.wq2_rptr(wq2_rptr), .rptr(rptr),
    .wclk(wclk), .wrst_n(wrst_n));

    w2r w2r (.rq2_wptr(rq2_wptr), .wptr(wptr),
    .rclk(rclk), .rrst_n(rrst_n));

    fifomem #(DSIZE, ASIZE) fifomem
    (.rdata(rdata), .wdata(wdata),
    .waddr(waddr), .raddr(raddr),
    .wclken(winc), .wfull(wfull),
    .wclk(wclk));

    read_inc #(ASIZE) read_inc
    (.rempty(rempty),
    .raddr(raddr),
    .rptr(rptr), .rq2_wptr(rq2_wptr),
    .rinc(rinc), .rclk(rclk),
    .rrst_n(rrst_n));

    write_inc #(ASIZE) write_inc
    (.wfull(wfull), .waddr(waddr),
    .wptr(wptr), .wq2_rptr(wq2_rptr),
    .winc(winc), .wclk(wclk),
    .wrst_n(wrst_n));

endmodule

module fifomem #(parameter DATASIZE = 8,
parameter ADDRSIZE = 3) 
(output [DATASIZE-1:0] rdata,
input [DATASIZE-1:0] wdata,
input [ADDRSIZE-1:0] waddr, raddr,
input wclken, full, wclk);
    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];
    assign rdata = mem[raddr];
    always @(posedge wclk)
    if (wclken && !full) mem[waddr] <= wdata;
endmodule


module r2w #(parameter ADDRSIZE = 3)
(output reg [ADDRSIZE:0] wq2_rptr,
input [ADDRSIZE:0] rptr,
input wclk, wrst_n);
        reg [ADDRSIZE:0] wq1_rptr;
        always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
    else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
endmodule


module w2r #(parameter ADDRSIZE = 3)
(output reg [ADDRSIZE:0] rq2_wptr,
input [ADDRSIZE:0] wptr,
input rclk, rrst_n);
    reg [ADDRSIZE:0] rq1_wptr;
    always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
    else {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule

module read_inc #(parameter ADDRSIZE = 3)
(output reg rempty,
output [ADDRSIZE-1:0] raddr,
output reg [ADDRSIZE :0] rptr,
input [ADDRSIZE :0] rq2_wptr,
input rinc, rclk, rrst_n);
    reg [ADDRSIZE:0] rbin;
    wire [ADDRSIZE:0] rgraynext, rbinnext;
    always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) {rbin, rptr} <= 0;
    else {rbin, rptr} <= {rbinnext, rgraynext};
    assign raddr = rbin[ADDRSIZE-1:0];
    assign rbinnext = rbin + (rinc & ~rempty);
    assign rgraynext = (rbinnext>>1) ^ rbinnext;
    assign rempty_val = (rgraynext == rq2_wptr);
    always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rempty <= 1'b1;
    else rempty <= rempty_val;
endmodule

module write_inc #(parameter ADDRSIZE = 3)
(output reg wfull,
output [ADDRSIZE-1:0] waddr,
output reg [ADDRSIZE :0] wptr,
input [ADDRSIZE :0] wq2_rptr,
input winc, wclk, wrst_n);
reg [ADDRSIZE:0] wbin;
    wire [ADDRSIZE:0] wgraynext, wbinnext;
    always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wbin, wptr} <= 0;
    else {wbin, wptr} <= {wbinnext, wgraynext};
        assign waddr = wbin[ADDRSIZE-1:0];
        assign wbinnext = wbin + (winc & ~wfull);
        assign wgraynext = (wbinnext>>1) ^ wbinnext;
        assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
    wq2_rptr[ADDRSIZE-2:0]});
    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) wfull <= 1'b0;
        else wfull <= wfull_val;
endmodule