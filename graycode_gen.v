module graycode_gen #(parameter ADDRSIZE = 4)(
                    input [ADDRSIZE:0] inp,
                    output[ADDRSIZE:0] out
);
    assign out = (inp >> 1)^(inp);
endmodule