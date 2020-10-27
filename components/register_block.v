module register_block(
    input [4:0] a1, a2, a3,
    input clk, we3,
    input [31:0] wd3, 
    output [31:0] rd1, rd2
);

    integer i;
    initial begin
        $dumpfile("test");
        for(i = 0; i < 32; i = i + 1) $dumpvars(0, registers[i]);
    end

    reg [31:0] registers [31:0];

    assign rd1 = registers[a1];
    assign rd2 = registers[a2];

    always @(posedge clk) begin
        if(we3) begin
            registers[a3] = wd3;
        end
        registers[0] = 0; // better solution?
    end
        
endmodule

