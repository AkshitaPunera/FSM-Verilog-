`timescale 1ns / 1ps

module tb_pattern_detector;

    reg clk, rst, din;
    wire detected;

    // Swap module name here to test Moore vs Mealy
    pattern_detector_mealy uut (
        .clk(clk), .rst(rst), .din(din), .detected(detected)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    // Test sequence: 1 1 0 1 1 0 1 1 0 1  -> contains overlapping '1101' matches
    reg [9:0] test_seq = 10'b1101101101;
    integer i;

    initial begin
        clk = 0; rst = 1; din = 0;
        #12 rst = 0;

        for (i = 9; i >= 0; i = i - 1) begin
            din = test_seq[i];
            @(posedge clk);
            #1 $display("Time=%0t din=%b state_detected=%b", $time, din, detected);
        end

        #20 $finish;
    end

endmodule