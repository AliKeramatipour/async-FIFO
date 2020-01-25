module write_inc #(parameter ADDRSIZE = 4)(
                output reg full,
                output [ADDRSIZE-1:0] write_address,
                output reg [ADDRSIZE :0] graycode_wptr,
                input [ADDRSIZE :0] graycode_rptr,
                input signal_write, wclk, rst);
    
    reg  [ADDRSIZE:0] write_counter;
    wire [ADDRSIZE:0] next_gray, next_write;
    
    assign write_address = write_counter[ADDRSIZE-1:0];
    assign next_write = write_counter + (signal_write & ~full);
    graycode_gen #(ADDRSIZE) inst_graycode_gen(next_write , next_gray);
    
    assign next_full = ( {~graycode_rptr[ADDRSIZE:ADDRSIZE-1], graycode_rptr[ADDRSIZE-2:0]} == next_gray);

    always @(posedge wclk or posedge rst) begin
        if (rst) begin
            {write_counter,graycode_wptr} <= 0;
            full <= 1'b0 ;
        end
        else begin
            write_counter  <= next_write;
            graycode_wptr <= next_gray;
            full <= next_full;
        end
    end
endmodule

