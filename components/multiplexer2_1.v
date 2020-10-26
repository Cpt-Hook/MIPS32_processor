module multiplexer2_1#(parameter width = 32) (
    input [width-1:0] d0, d1,
    input select,
    output wire [width-1:0] out
);

    assign out = select? d1 : d0;

endmodule

