module pattern_detector_moore (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire detected
);

    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // '1'
    localparam S2 = 3'b010; // '11'
    localparam S3 = 3'b011; // '110'
    localparam S4 = 3'b100; // '1101' -> detected state

    reg [2:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S2 : S0;
            S2: next_state = din ? S2 : S3;
            S3: next_state = din ? S4 : S0;
            S4: next_state = din ? S2 : S0;   // overlap handling from detected state
            default: next_state = S0;
        endcase
    end

    // Moore output: pure function of state, registered so no combinational glitch
    assign detected = (state == S4);

endmodule

    // Moore output: pure function of state, registered so no combinational glitch
    assign detected = (state == S4);

endmodule
