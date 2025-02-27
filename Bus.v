module Bus (
    output wire [31:0] BusMuxOut,
    
    // Mux Inputs
    input [31:0] BusMuxInR0, input [31:0] BusMuxInR1, input [31:0] BusMuxInR2, input [31:0] BusMuxInR3, 
    input [31:0] BusMuxInR4, input [31:0] BusMuxInR5, input [31:0] BusMuxInR6, input [31:0] BusMuxInR7, 
    input [31:0] BusMuxInR8, input [31:0] BusMuxInR9, input [31:0] BusMuxInR10, input [31:0] BusMuxInR11, 
    input [31:0] BusMuxInR12, input [31:0] BusMuxInR13, input [31:0] BusMuxInR14, input [31:0] BusMuxInR15, 
    input [31:0] BusMuxInHI, input [31:0] BusMuxInLO, input [31:0] BusMuxInZhigh, input [31:0] BusMuxInZlow, 
    input [31:0] BusMuxInPC, input [31:0] BusMuxInMDR, input [31:0] BusMuxInCsignExtend, input [31:0] BusMuxInInPort,

    // Control Signals
    input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, 
    R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, 
    PCout, MDRout, InPortout, Cout
);

reg [31:0] q;
reg [4:0] select;
reg [23:0] temp;
always @(*) begin
    temp = {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, 
            R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, 
            Zlowout, PCout, MDRout, InPortout, Cout};
		case (temp) 
        
        32'h00000001: select = 5'd23;
        32'h00000002: select = 5'd22;
        32'h00000004: select = 5'd21;
        32'h00000008: select = 5'd20;
        32'h00000010: select = 5'd19;
        32'h00000020: select = 5'd18;
        32'h00000040: select = 5'd17;
        32'h00000080: select = 5'd16;
        32'h00000100: select = 5'd15;
        32'h00000200: select = 5'd14;
        32'h00000400: select = 5'd13;
        32'h00000800: select = 5'd12;
        32'h00001000: select = 5'd11;
        32'h00002000: select = 5'd10;
        32'h00004000: select = 5'd9;
        32'h00008000: select = 5'd8;
        32'h00010000: select = 5'd7;
        32'h00020000: select = 5'd6;
        32'h00040000: select = 5'd5;
        32'h00080000: select = 5'd4;
        32'h00100000: select = 5'd3;
        32'h00200000: select = 5'd2;
        32'h00400000: select = 5'd1;
        32'h00800000: select = 5'd0;
		  		  
	endcase
end
        
always @(*) begin
    case (select) // Evaluate which signal is high (priority encoding)
        5'd0: q = BusMuxInR0;
        5'd1: q = BusMuxInR1;
        5'd2: q = BusMuxInR2;
        5'd3: q = BusMuxInR3;
        5'd4: q = BusMuxInR4;
        5'd5: q = BusMuxInR5;
        5'd6: q = BusMuxInR6;
        5'd7: q = BusMuxInR7;
        5'd8: q = BusMuxInR8;
        5'd9: q = BusMuxInR9;
        5'd10: q = BusMuxInR10;
        5'd11: q = BusMuxInR11;
        5'd12: q = BusMuxInR12;
        5'd13: q = BusMuxInR13;
        5'd14: q = BusMuxInR14;
        5'd15: q = BusMuxInR15;
        5'd16: q = BusMuxInHI;
        5'd17: q = BusMuxInLO;
        5'd18: q = BusMuxInZhigh;
        5'd19: q = BusMuxInZlow;
        5'd20: q = BusMuxInPC;
        5'd21: q = BusMuxInMDR;
        5'd22: q = BusMuxInInPort;
        5'd23: q = BusMuxInCsignExtend;
    endcase
end

assign BusMuxOut = q;

endmodule
