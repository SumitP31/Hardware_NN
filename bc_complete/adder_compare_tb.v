`timescale 1ns/1ps
`include "adder_compare.v"
module adder_compare_tb;

    reg clk, rst;
    reg [11:0] input_array[8:0];
    reg [12:0] bias;
    wire out;

    // Instantiate the module
    adder_compare #(.CONST_VAL(1'b0)) uut (
        .clk(clk),
        .rst(rst),
        .input_array_0(input_array[0]),
        .input_array_1(input_array[1]),
        .input_array_2(input_array[2]),
        .input_array_3(input_array[3]),
        .input_array_4(input_array[4]),
        .input_array_5(input_array[5]),
        .input_array_6(input_array[6]),
        .input_array_7(input_array[7]),
        .input_array_8(input_array[8]),
        .bias(bias),
        .out(out)
    );

    integer i;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns clock period

    initial begin
        $display("Time\tReset\tOutput");

        // Initialize
        rst = 1;
        bias = 0;
        for (i = 0; i < 9; i = i + 1) input_array[i] = 0;
        #10;

        rst = 0;
        // #10;

       // Test 2: High sum
        for (i = 0; i < 9; i = i + 1) input_array[i] = 12'b001000000000; //0.8 
        bias = 12'b010000000000;
        #10;
        $display("%0dns\t%b\t%b", $time, uut.sum, out);


        // Test 2: High sum
        for (i = 0; i < 9; i = i + 1) input_array[i] = 12'b000110011010; //0.8 
        bias = 12'b010111001100;
        #10;
        $display("%0dns\t%b\t%b", $time, uut.sum, out);

        // Test 3: Exact threshold
        for (i = 0; i < 9; i = i + 1) input_array[i] = 12'b000110011010; //0.8
        // input_array[8] = 12'b000110011010;
        bias = 12'b010111001100;
        #10;
        $display("%0dns\t%b\t%b", $time, uut.sum, out);

        // Reset again
        // rst = 1; #10;

        for (i = 0; i < 9; i = i + 1) input_array[i] = 12'b000010011001; // 0.3  
        // input_array[8] = 12'b000110011010;
        bias = 12'b010111001100;
        #10;
        $display("%0dns\t%b\t%b", $time, uut.sum, out);

        $finish;
    end

endmodule
