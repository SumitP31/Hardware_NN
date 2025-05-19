`timescale 1ns / 1ps

`define data 11

module fixed_point_adder (
    input  signed [`data:0] a,  // Q5.6 signed fixed-point number
    input  signed [`data:0] b,  // Q5.6 signed fixed-point number
    output reg signed [`data+1:0] sum // Output is 13 bits to handle overflow
);

    wire signed [`data+1:0] out;

    assign out = a + b;
    
    always @(*)begin
        if(out[`data+1]!=0) begin
            sum = ~out;
        end
        else begin
            sum = out;
        end

    end

endmodule




module tb_fixed_point_adder;

    // Inputs
    reg signed [11:0] a;
    reg signed [11:0] b;

    // Output
    wire signed [12:0] sum;

    // Instantiate the Unit Under Test (UUT)
    fixed_point_adder uut (
        .a(a), 
        .b(b), 
        .sum(sum)
    );

    // Convert float to Q5.6 fixed-point format
    function [11:0] float_to_q5_6;
        input real val;
        begin
            float_to_q5_6 = $rtoi(val * 64); // 2^6 = 64
        end
    endfunction

    // Convert Q5.6 back to float for readable display
    function real q5_6_to_float;
        input signed [12:0] val;
        begin
            q5_6_to_float = val / 64.0;
        end
    endfunction

    initial begin
        // Monitor values
        $display("Time\t\ta\t\tb\t\tsum");
        // $monitor("%0dns\t%f\t%f\t%f", 
        //          $time,
        //          q5_6_to_float(a),
        //          q5_6_to_float(b),
        //          q5_6_to_float(sum));

        // Test Case 1: 3.25 + 1.75 = 5.0
        a = float_to_q5_6(3.25);
        b = float_to_q5_6(1.75);
        #10;
        $display("%0dns\t%b\t%b\t%b", $time, a, b, sum); ///10 

        // Test Case 2: -2.5 + 1.0 = -1.5
        a = float_to_q5_6(-2.5);
        b = float_to_q5_6(1.0);
        #10;
        $display("%0dns\t%b\t%b\t%b", $time, a, b, sum);////20

        // Test Case 3: -3.75 + (-2.25) = -6.0
        a = float_to_q5_6(-3.75);
        b = float_to_q5_6(-2.25);
        #10;
        $display("%0dns\t%b\t%b\t%b", $time, a, b, sum);/////30

        // Test Case 4: 15.5 + (-15.5) = 0.0
        a = float_to_q5_6(15.5);
        b = float_to_q5_6(-15.5);
        #10;
        $display("%0dns\t%b\t%b\t%b", $time, a, b, sum);////40

        // Test Case 5: Edge test: 31.984 + 0
        a = float_to_q5_6(31.984);  // max value in Q5.6 ~ 31.984375
        b = float_to_q5_6(0.0);
        #10;
        $display("%0dns\t%b\t%b\t%b", $time, a, b, sum);////50

        $finish;
    end

endmodule
