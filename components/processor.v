module processor( input         clk, reset,
                  output [31:0] PC,
                  input  [31:0] instruction,
                  output        WE,
                  output [31:0] address_to_mem,
                  output [31:0] data_to_mem,
                  input  [31:0] data_from_mem
                );

    wire[31:0] srcA, srcB, ALUOut, pc_out, pc_in, constant_four, WriteData;
    wire [3:0] ALUControl;
    wire RegWrite, zero, MemWrite;
    supply1 logical_one;

    assign constant_four = 4;
    assign PC = pc_out;
    assign address_to_mem = ALUOut;
    assign WE = MemWrite;
    assign data_to_mem = WriteData;

    control_unit control_unit(
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .shamt(instruction[10:6]),
        .ALUControl(ALUControl),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite)
    );

    register_block register_block(
        .a1(instruction[25:21]),
        .a2(instruction[20:16]),
        .a3(instruction[20:16]),
        .rd1(srcA),
        .rd2(WriteData),
        .clk(clk),
        .we3(RegWrite),
        .wd3(data_from_mem)
    );

    sign_extender_16_32 sign_extender_16_32(
        instruction[15:0], srcB
    );

    alu alu(
        srcA, srcB, ALUControl, ALUOut, zero
    );

    adder pc_adder(pc_out, constant_four, pc_in);

    register pc_register(pc_in, logical_one, clk, reset, pc_out);

endmodule

