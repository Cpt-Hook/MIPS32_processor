module pc_multiplexor(
    input[31:0] jr, jal, beq, PCPlus4,
    input PCSrcBeq, PCSrcJr, PCSrcJal,
    output reg [31:0] out
);
    always@(*) begin
        if(PCSrcBeq)
            out = beq;
        else if(PCSrcJr)
            out = jr;
        else if(PCSrcJal)
            out = jal;
        else
            out = PCPlus4;
    end
endmodule

