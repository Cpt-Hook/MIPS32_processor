module register(
    input [31:0] data_in,
    input we, clk, reset,
    output reg [31:0] data_out
);

    always @(posedge clk)
        if(we) begin
            if(reset)
                data_out = 0;
            else
                data_out = data_in;
        end
endmodule

