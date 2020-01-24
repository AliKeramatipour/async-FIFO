module write_inc_TB();

    parameter ADDRSIZE = 4;
    reg clk = 0;
    always #100 clk = ~clk;

    reg signal_write = 0;
    reg rst = 0;
    reg[ADDRSIZE:0] graycode_rptr = 5'b00000;
    

    wire full;
    wire[ADDRSIZE - 1:0] write_address;
    wire[ADDRSIZE:0] graycode_wptr;


    write_inc #(ADDRSIZE) UUT(
                full,
                write_address,
                graycode_wptr,
                graycode_rptr,
                signal_write, clk, rst);
    
    initial begin
        rst = 1;
        signal_write = 1;
        #100
        rst = 0;
        #100
        #64000
        $stop;
    end

endmodule
