module MDR #(parameter DATA_WIDTH_IN = 32,DATA_WIDTH_OUT = 32, INIT = 32'h0)(
    input wire clear, clock, MDRin, Read,
    input wire [DATA_WIDTH_IN-1:0] BusMuxOut, Mdatain,
    output wire [DATA_WIDTH_OUT-1:0] BusMuxInMDR // Output stored value
);

reg [DATA_WIDTH_IN-1:0] MDMux; // MUX output
reg [DATA_WIDTH_IN-1:0] MDR_Reg; // MDR storage register

// MUX Logic: Select data source (Bus or Memory)
always @(*) begin
    case (Read)
        1'b0: MDMux = BusMuxOut;  // Select internal bus input
        1'b1: MDMux = Mdatain;    // Select memory input
        default: MDMux = 32'b0;
    endcase
end

// Register Logic: Store MDMux data when MDRin is HIGH
always @(posedge clock or posedge clear) begin
    if (clear)
        MDR_Reg <= INIT; // Reset to initial value
    else if (MDRin) 
        MDR_Reg <= MDMux; // Store selected input
end

// Output Logic: BusMuxIn-MDR always holds the stored value

assign BusMuxInMDR = MDR_Reg;

endmodule
