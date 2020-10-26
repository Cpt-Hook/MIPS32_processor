module processor( input         clk, reset,
                  output [31:0] PC,
                  input  [31:0] instruction,
                  output        WE,
                  output [31:0] address_to_mem,
                  output [31:0] data_to_mem,
                  input  [31:0] data_from_mem
                );
    supply1 logical1;
    supply0 logical0;

    wire[4:0] constant_31;
    assign constant_31 = 31;

    wire [31:0] PC_wire;
    assign PC = PC_wire;

    wire [31:0] PCPlus4;
    wire [31:0] PC_mult_wire;
    wire [31:0] srcA, srcB;

    wire [31:0] Instr;
    assign Instr = instruction;
    
    wire [31:0] four;
    assign four = 4;

    wire [31:0] PCJal;
    assign PCJal = {PCPlus4[31:28], Instr[25:0], logical0, logical0};

    output PCSrcJal, PCSrcJr, RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch;
    output [3:0] ALUControl;

    assign WE = MemWrite;

    wire zero;
    wire PCSrcBeq;
    assign PCSrcBeq = Branch & zero;

    wire[4:0] WriteReg;
    wire[4:0] A3_mult_A3_wire;
    wire[31:0] WD3_mult_WD3_wire;

    wire[31:0] WriteData;
    assign data_to_mem = WriteData;

    wire[31:0] ALUOut;
    assign address_to_mem = ALUOut;

    wire[31:0] SignImm;
    wire[31:0] SignImm_times_4;

    wire[31:0] ReadData;
    assign ReadData = data_from_mem;

    wire[31:0] Result;
    wire[31:0] PCBranch;

    control_unit control_unit(
        .opcode(Instr[31:26]),
        .funct(Instr[5:0]),
        .shamt(Instr[10:6]),
        .PCSrcJr(PCSrcJr),
        .PCSrcJal(PCSrcJal),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    register_block register_block(
        .we3(RegWrite),
        .a1(Instr[25:21]),
        .a2(Instr[20:16]),
        .a3(A3_mult_A3_wire),
        .rd1(srcA),
        .rd2(WriteData),
        .wd3(WD3_mult_WD3_wire),
        .clk(clk)
    );

    sign_extender_16_32 sign_extender_16_32(
        .data_in(Instr[15:0]),
        .data_out(SignImm)
    );

    alu alu(
        .ALUControl(ALUControl),
        .srcA(srcA),
        .srcB(srcB),
        .zero(zero),
        .result(ALUOut)
    );

    adder PC_adder(
        PC_wire, four, PCPlus4
    );

    register pc_register(
        .data_in(PC_mult_wire),
        .data_out(PC_wire),
        .clk(clk),
        .we(logical1),
        .reset(reset)
    );

    pc_multiplexor pc_multiplexor(
        .PCSrcJr(PCSrcJr),
        .PCSrcJal(PCSrcJal),
        .PCSrcBeq(PCSrcBeq),
        .PCPlus4(PCPlus4),
        .jr(srcA),
        .jal(PCJal),
        .out(PC_mult_wire),
        .beq(PCBranch)
    );

    multiplexer2_1 #(5) A3_mult(
        .d0(WriteReg),
        .d1(constant_31),
        .select(PCSrcJal),
        .out(A3_mult_A3_wire)
    );

    multiplexer2_1 WD3_mult(
        .select(PCSrcJal),
        .out(WD3_mult_WD3_wire),
        .d1(PCPlus4),
        .d0(Result)
    );

    multiplexer2_1 #(5) RegDst_mult(
        .select(RegDst),
        .d0(Instr[20:16]),
        .d1(Instr[15:11]),
        .out(WriteReg)
    );

    multiplexer2_1 ALUSrc_mult(
        .select(ALUSrc),
        .d0(WriteData),
        .d1(SignImm),
        .out(srcB)
    );

    multiplexer2_1 MemToReg_mult(
        .select(MemToReg),
        .d0(ALUOut),
        .d1(ReadData),
        .out(Result)
    );

    multiplier4 multiplier4(
        .data_in(SignImm),
        .data_out(SignImm_times_4)
    );

    adder PCBranch_adder(
        SignImm_times_4, PCPlus4, PCBranch
    );

endmodule

