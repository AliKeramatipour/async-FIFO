module fifo #(parameter WORDSIZE = 8,
            parameter ADDRSIZE = 3)
            (
                input[WORDSIZE-1:0] write_data,
                input               signal_read, rclk,
                input               signal_write, wclk,
                input               rst,
                output              full,empty,
                output[WORDSIZE-1:0]read_data
            );

        wire [ADDRSIZE:0] rptrToWclk,
                          wptrToRclk,
                          rptr,
                          wptr;
        wire [ADDRSIZE-1:0] read_address,
                            write_address;


        r2w #(ADDRSIZE) _r2w(._2nd_reg(rptrToWclk), .graycode_rptr(rptr), .wclk(wclk), .rst(rst));
        w2r #(ADDRSIZE) _w2r(._2nd_reg(wptrToRclk), .graycode_wptr(wptr), .rclk(rclk), .rst(rst));
        fifomem #(WORDSIZE,ADDRSIZE) _fifomem(.waddr(write_address), .raddr(read_address), .rdata(read_data), .wdata(write_data), .full(full),
                                            .wclk(wclk));
                                            
        read_inc  #(ADDRSIZE) _read_inc (.empty(empty), .read_address(read_address), .graycode_rptr(rptr), .graycode_wptr(wptr),
              .signal_read(signal_read), .rclk(rclk), .rst(rst));
        write_inc #(ADDRSIZE) _write_inc(.full(full), .write_address(write_address), .graycode_wptr(wptr), .graycode_rptr(rptr),
                            .signal_write(signal_write), .wclk(wclk), .rst(rst));
endmodule