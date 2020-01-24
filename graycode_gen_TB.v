module graycode_gen_TB();
    parameter ADDRSIZE = 3;
    reg[ADDRSIZE:0]  inp = 0;
    wire[ADDRSIZE:0] out;
    graycode_gen #(ADDRSIZE) gcg(inp, out);

    always #100 inp <= inp + 1;
    initial begin
        #2000
        $stop;
    end
endmodule