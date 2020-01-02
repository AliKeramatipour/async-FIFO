module write_inc #(parameter ADDRSIZE = 4)(
                output reg full,
                output [ADDRSIZE-1:0] write_address,
                output reg [ADDRSIZE :0] graycode_wptr,
                input [ADDRSIZE :0] graycode_rptr,
                input signal_write, wclk, rst);
    
    reg  [ADDRSIZE:0] write_counter;
    wire [ADDRSIZE:0] next_gray;
    
    assign write_address = write_counter[ADDRSIZE-1:0];
    graycode_gen inst_graycode_gen(write_counter + 1 , next_gray);
    assign next_full = ( {~graycode_wptr[ADDRSIZE:ADDRSIZE-1], graycode_wptr[ADDRSIZE-2:0]} == next_gray);

    always @(posedge wclk or posedge rst) begin
        if (rst) begin
            {write_counter,graycode_wptr} <= 0;
            full <= 1'b0 ;
        end
        else begin
            if ( signal_write & ~full ) begin
                write_counter  <= write_counter + 1;
                graycode_wptr <= next_gray;
            end
            full <= next_full;
        end
    end
endmodule

