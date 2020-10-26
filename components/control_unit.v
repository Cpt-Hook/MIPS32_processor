module control_unit(
    input [5:0] opcode, funct,
    input [4:0] shamt,
    output PCSrcJal, PCSrcJr, RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch,
    output [3:0] ALUControl
);

    wire [1:0] ALUOp;

    main_decoder main_decoder(opcode, PCSrcJal, PCSrcJr, RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch, ALUOp);
    alu_op_decoder alu_op_decoder(ALUOp, shamt, funct, ALUControl);
endmodule


module main_decoder(
    input[5:0] opcode,
    output reg PCSrcJal, PCSrcJr, RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch,
    output reg [1:0] ALUOp
);

    always@(*) begin
        case (opcode)
            'b000000: begin // R type instruction
                RegWrite = 'b1;
                RegDst = 'b1;
                ALUSrc = 'b0;
                ALUOp = 'b10;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
            'b100011: begin // lw
                RegWrite = 'b1;
                RegDst = 'b0;
                ALUSrc = 'b1;
                ALUOp = 'b00;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b1;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
            'b101011: begin // sw
                RegWrite = 'b0;
                RegDst = 'b0;
                ALUSrc = 'b1;
                ALUOp = 'b00;
                Branch = 'b0;
                MemWrite = 'b1;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
            'b000100: begin // beq
                RegWrite = 'b0;
                RegDst = 'b0;
                ALUSrc = 'b0;
                ALUOp = 'b01;
                Branch = 'b1;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
            'b001000: begin // addi
                RegWrite = 'b1;
                RegDst = 'b0;
                ALUSrc = 'b1;
                ALUOp = 'b00;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
            'b000011: begin // jal
                RegWrite = 'b1;
                RegDst = 'b0;
                ALUSrc = 'b0;
                ALUOp = 'b00;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b1;
                PCSrcJr = 'b0;
            end
            'b000111: begin // jr
                RegWrite = 'b0;
                RegDst = 'b0;
                ALUSrc = 'b0;
                ALUOp = 'b00;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b1;
            end
            'b011111: begin // addu[_s].qb
                RegWrite = 'b1;
                RegDst = 'b1;
                ALUSrc = 'b0;
                ALUOp = 'b11;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
            default: begin
                RegWrite = 'b0;
                RegDst = 'b0;
                ALUSrc = 'b0;
                ALUOp = 'b00;
                Branch = 'b0;
                MemWrite = 'b0;
                MemToReg = 'b0;
                PCSrcJal = 'b0;
                PCSrcJr = 'b0;
            end
        endcase
    end
endmodule

module alu_op_decoder(
    input [1:0] ALUOp,
    input[4:0] shamt,
    input[5:0] funct,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            'b00: ALUControl = 'b0010; // addition
            'b01: ALUControl = 'b0110; //subtraction
            'b10: begin
                case (funct)
                    'b100000: ALUControl = 'b0010; //addition
                    'b000010: ALUControl = 'b0110; //subtraction
                    'b100100: ALUControl = 'b0000; //and
                    'b100101: ALUControl = 'b0001; //or
                    'b101010: ALUControl = 'b0111; //slt
                     default: ALUControl = 'b0000;
                endcase
            end
            'b11: begin
                if (funct == 'b010000) // only 'b010000 funct valid
                    case (shamt)
                        'b000000: ALUControl = 'b1000; //addition byte after byte
                        'b001000: ALUControl = 'b0111; //saturated addition byte after byte
                         default: ALUControl = 'b0000;
                    endcase
                else 
                    ALUControl = 'b0000;
            end
            default: ALUControl = 'b0000;
        endcase
    end
endmodule

