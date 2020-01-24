module read_inc_TB();

    parameter ADDRSIZE = 4;
    reg clk = 0;
    always #100 clk = ~clk;

    reg signal_read;
    reg rst = 0;
    reg[ADDRSIZE:0] graycode_wptr = 5'b01111;
    
    wire empty;
    wire[ADDRSIZE - 1:0] read_address;
    wire[ADDRSIZE:0] graycode_rptr;


    read_inc #(ADDRSIZE) UUT(
                empty,
                read_address,
                graycode_rptr,
                graycode_wptr,
                signal_read, clk, rst);
    
    initial begin
        rst = 1;
        #100
        rst = 0;
        #100
        signal_read = 1;
        #2000
        $stop;

    end

endmodule
