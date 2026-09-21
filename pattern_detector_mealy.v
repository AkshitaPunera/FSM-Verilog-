module pattern_detector_mealy (
    input  wire clk,
    input  wire rst,     // synchronous active-high reset
    input  wire din,      // serial input bit
    output reg  detected  // pulses high for 1 cycle when '1101' is found
);

    // State encoding
    localparam S0 = 3'b000; // no match yet
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'
    // S3 + din=1 -> match found, goes back to S1 (overlap: last bit '1' could start new seq)

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S2 : S0;
            S2: next_state = din ? S2 : S3;   // stay S2 on '1' (handles "111...")
            S3: next_state = din ? S1 : S0;   // match on '1'; overlap -> S1
            default: next_state = S0;
        endcase
    end

    // Mealy output logic (combinational, depends on state AND input)
    always @(*) begin
        detected = (state == S3) && din;
    end

endmodule
