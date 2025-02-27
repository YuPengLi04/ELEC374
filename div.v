module div (
    input wire [31:0] dividend,  // Dividend (Q)
    input wire [31:0] divisor,   // Divisor (M)
	 output reg [63:0] Result,
    output reg valid             // Indicates when computation is complete
);

    // Internal registers
    reg [31:0] A;                // Accumulator
    reg [31:0] Q;                // Quotient register
    reg [31:0] M;                // Divisor register
    reg [5:0] count;             // Counter for 32 iterations
	 reg [31:0] local_M, local_Q;
	 integer i,j;

    always @(*) begin
        // Initialize registers
        A = 32'b0;               // Clear accumulator
        Q = dividend;            // Load dividend into Q
        M = divisor;             // Load divisor into M
        count = 6'd32;           // Set counter for 32 iterations
        valid = 1'b0;            // Clear valid flag
		  i = 0;
		  j = 0;

		  if (divisor[31] == 1) begin
				local_M = ~M+1;
				i = 1;
		  end 
		  else
				local_M = M;
			
		  if (dividend[31] == 1) begin
				local_Q = ~Q+1;
				j = 1;
		  end
		  else
				local_Q = Q;

        while (count > 0) begin
            // Shift left {A, Q}
            A = {A[30:0], local_Q[31]};
            local_Q = {local_Q[30:0], 1'b0};

            // Subtract M from A
            A = A - local_M;

            if (A[31]) begin
                // If result is negative, restore A and set LSB of Q to 0
                A = A + local_M;
                local_Q[0] = 1'b0;
            end else begin
                // If result is positive, set LSB of Q to 1
                local_Q[0] = 1'b1;
            end

            count = count - 1;   // Decrement counter
        end

	// Division complete after all bits are processed
	valid = 1'b1;            // Set valid flag to indicate completion
	if (i==1)
		local_Q = ~local_Q+1;
	if (j == 1)
		local_Q = ~local_Q+1;
		A = ~A+1;
	Result = {A, local_Q};
	end
endmodule
