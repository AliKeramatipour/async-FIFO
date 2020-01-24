module read_inc #(parameter ADDRSIZE = 4)(
                output reg empty,
                output [ADDRSIZE-1:0] read_address,
                output reg [ADDRSIZE :0] graycode_rptr,
                input [ADDRSIZE :0] graycode_wptr,
                input signal_read, rclk, rst);
    
    reg  [ADDRSIZE:0] read_counter;
    wire [ADDRSIZE:0] next_gray, next_read;
    
    assign read_address = read_counter[ADDRSIZE-1:0];
    assign next_read = read_counter + (signal_read & ~empty) ;
    graycode_gen #(ADDRSIZE) inst_graycode_gen(next_read , next_gray);
    
    assign next_empty = (graycode_wptr == next_gray);

    always @(posedge rclk or posedge rst) begin
        if (rst) begin
            {read_counter,graycode_rptr} <= 0;
            empty <= 1'b1 ;
        end
        else begin
            if ( signal_read & ~empty ) begin
                read_counter  <= read_counter + 1;
                graycode_rptr <= next_gray;
            end
            empty <= next_empty;
        end
    end
endmodule