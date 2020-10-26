module alu(
    input [31:0] srcA, srcB,
    input [3:0] ALUControl,
    output reg [31:0] result,
    output zero
);

    assign zero = (result == 0? 1 : 0);

    integer i;

    always @(*) begin
        case (ALUControl)
            'b0010: result = srcA + srcB;
            'b0110: result = srcA - srcB;
            'b0000: result = srcA & srcB;
            'b0001: result = srcA | srcB;
            'b0011: result = srcA ^ srcB;
            'b0111: result = srcA < srcB;
            'b1000: begin // sum byte by byte
                for (i = 0; i < 32; i = i + 8) begin
                    result[i+:8] = srcA[i+:8] + srcB[i+:8];
                end
            end
            'b1001: begin // saturated sum byte by byte
                for (i = 0; i < 32; i = i + 8) begin
                    if ((srcA[i+:8] + srcB[i+:8]) > 'b1111_1111) // check for overflow
                        result[i+:8] = 'b1111_1111;
                    else
                        result[i+:8] = srcA[i+:8] + srcB[i+:8];
                end
            end
            default : result = 'h00_00_00_00; // is this OK?
        endcase
    end
endmodule

