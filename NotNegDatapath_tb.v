`timescale 1ns/10ps
module NotNegDatapath_tb;

  reg Zout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, 
      R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, 
      PCout, MDRout, InPortout, Cout;		
		
  reg MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin;
  reg IncPC, Read, R0in, R1in, R2in, R3in, R4in, 
  R5in,R6in,R7in,R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, ZhighIn, ZlowIn;
  reg clock, clear;
  reg [4:0] opcode;
  reg [31:0] Mdatain;

  parameter  Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
                       Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, T0 = 4'b0110, T1 = 4'b0111,
                       T2 = 4'b1000, T3 = 4'b1001, T4 = 4'b1010, T5 = 4'b1011;
  reg [3:0] Present_state = Default;

  DataPath DUT(clock, clear, Zout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, 
    R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, 
    PCout, MDRout, InPortout, Cout, Zin, Yin, R0in, R1in,
  R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in,
  R11in, R12in, R13in, R14in, R15in, PCin, IRin, HIin,
  LOin, MARin, MDRin, Read, ZhighIn, ZlowIn, Mdatain, opcode);

initial
 begin
  clock = 0;
  clear = 0;
  forever #10 clock = ~clock;
end

always@(posedge clock)
  begin
    case(Present_state)
      Default : Present_state = Reg_load1a;
      Reg_load1a : Present_state = Reg_load1b;
      Reg_load1b : Present_state = Reg_load2a;
      Reg_load2a : Present_state = Reg_load2b;
      Reg_load2b : Present_state = Reg_load3a;
		Reg_load3a : Present_state = T0;
      T0 : Present_state = T1;
      T1 : Present_state = T2;
      T2 : Present_state = T3;
      T3 : Present_state = T4;
		T4 : Present_state = T5;
    endcase
  end
  
always@(Present_state)
  begin
    case(Present_state)
      Default: begin
          PCout<=0; Zlowout<=0; MDRout<=0;
          R0out<=0; R5out<=0; MARin<=0;
          PCin<=0; MDRin<=0; IRin<=0; Yin<=0;
          IncPC<=0; Read<=0; opcode<=5'b00000;
          R0in<=0; R5in<=0; Mdatain<=32'h00000000;
	       R1out=0; R2out=0; R3out=0; R4out=0; R6out=0; R7out=0; R8out=0; R9out=0; 
		    R10out=0; R11out=0; R12out=0; R13out=0; R14out=0; R15out=0; HIout=0; LOout=0; Zhighout=0; Zlowout=0; 
		    MDRout=0; InPortout=0; Cout<=0; Zin<=0; ZhighIn<=0; ZlowIn<=0;
      end
      Reg_load1a: begin
	       Read<=1; MDRin<=1;
          Mdatain<=32'h00000044;
      end
      Reg_load1b: begin
          Read<=0; MDRin<=0;
          MDRout<=1; R0in<=1;
      end
      Reg_load2a: begin
          MDRout<=0; R0in<=0; // initialize R0 with value 0x44
	      
          Read<=1; MDRin<=1;	      
          Mdatain<=32'h000000024;
      end
      Reg_load2b: begin
          Read<=0; MDRin<=0;
          MDRout<=1; R5in<=1;
      end
      Reg_load3a: begin
			 MDRout<=0; R5in<=0; //initialize R5 with the value 0x24
		    PCout<=1; MARin<=1; opcode<=5'b11111; ZlowIn<=1;
      end
      T0: begin
			 PCout<=0; MARin<=0; opcode<=5'b00000; ZlowIn<=0;
			 Zlowout<=1; PCin<=1;
      end
      T1: begin
			 Zlowout<=0; PCin<=0;
			 Read<=1; MDRin<=1;
		    Mdatain<=32'h8A800000;  //opcode for "neg r5,r0" = 32'h8A800000; opcode for "not r5,r0" = 32'h92800000
      end
      T2: begin
			 Zlowout<=0; PCin<=0; Read<=0; MDRin<=0;
          MDRout<=1; IRin<=1;
      end
      T3: begin	
			 MDRout<=0; IRin<=0;
          R0out<=1; opcode<=5'b10010; ZlowIn<=1; //replace "NEG b10001" with "NOT b10010" on this line
      end
      T4: begin
			 R0out<=0; opcode<=5'b00000; ZlowIn<=0;
          Zlowout<=1; R5in<=1; //saves to R5
      end
		T5: begin
			 Zlowout<=0; R5in<=0;
		end
	 endcase
  end
endmodule
