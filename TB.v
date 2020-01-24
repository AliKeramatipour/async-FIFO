`include "beh_fifo.v"
`include "main_wrapper.v"

`define WRITE(data) w_data = data;\
    winc = 1;\
    #(2*Tw) \
    winc = 0;

`define READ rinc = 1;\
    #(2*Tr) \
    rinc = 0;


module TB();
    reg [10:0] Tw, Tr;
    wire [7:0] bf_rdata, sf_rdata;
    wire bf_wfull, sf_wfull, bf_rempty, sf_rempty;
    reg [7:0] w_data;
    reg winc, wclk, rinc, rclk, rst;

    beh_fifo bf(bf_rdata, bf_wfull, bf_rempty, w_data, winc, wclk, rinc, rclk, rst);
    main_wrapper sf(sf_rdata, sf_wfull, sf_rempty, w_data, winc, wclk,  rinc, rclk, rst);

    always #Tr rclk = ~rclk; 
    always #Tw wclk = ~wclk; 


    always @(posedge rclk) begin
        assert (bf_rdata == sf_rdata);
        assert (bf_rempty == sf_rempty);
    end

    always @(posedge wclk) begin
        assert (bf_wfull == sf_wfull);
    end
    
    integer i, j, k;
    initial begin
        wclk = 0;
        rclk = 0;
        // These fors generate 2 clocks with different ratios in range [1/10 , 10]
        for (i = 1; i<11; i = i+1) begin
            Tr = i;
            for (j =1; j<11; j = j+1) begin
                Tw = j;
                rst = 1;
                #20
                rst = 0;
                #20 

                // read when empty
                `READ
                // write first data
                `WRITE(1)
                // read first data
                `READ
                // == fifo is empty == 
                #(20)
                // 2 X write
                `WRITE(2)
                `WRITE(3)

                ///   EACH FOR IS DONE FOR 9 TIMES SO THE POINTER ITERATES BETWEEN ALL POSSIBLE VALUES  
                for (k=0; k<9; k=k+1) begin // read and write when normal 
                    // write data
                    `WRITE(k + 4)
                    // read data
                    `READ
                end

                for (k=0; k<9; k=k+1) begin // 2 X read and 2 X write when normal 
                    // write data
                    `WRITE(k + 204)
                    `WRITE(k + 104)
                    // read data
                    `READ
                    `READ
                end

                for (k=0; k<2; k=k+1) `READ
                // == fifo is empty == 

                for (k=0; k<9; k=k+1) begin // read and write when empty 
                    // write data
                    `WRITE(k + 15)
                    // read data
                    `READ
                end
                for (k=0; k<9; k=k+1) begin // 2 X read and 2 X write when empty 
                    // write data
                    `WRITE(k + 215)
                    `WRITE(k + 115)
                    // read data
                    `READ
                    `READ
                end

                // == fifo is empty == 
                for (k=0; k<9; k=k+1) begin // 2 X write and read  
                    // read data
                    `READ
                    // write data
                    `WRITE(k + 24)
                    `WRITE(k + 124)
                end
                // == fifo is full == 

                for (k=0; k<9; k=k+1) begin // read and write when full 
                    // read data
                    `READ
                    // write data
                    `WRITE(k + 33)
                end

                for (k=0; k<9; k=k+1) begin // 2 X read and 2 X write when full 
                    // read data
                    `READ
                    `READ
                    // write data
                    `WRITE(k + 233)
                    `WRITE(k + 133)
                end
                // == fifo is full == 

                for (k=0; k<9; k=k+1) begin // 2 X read and write when full 
                    // write data
                    `WRITE(k + 133)
                    // read data
                    `READ
                    `READ
                end
                // == fifo is empty == 
            end
        end
        $finish;
    end

endmodule
