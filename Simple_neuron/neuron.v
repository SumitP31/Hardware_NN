`include "binary_fraction_multiplier.v"
`include "fp_sum.v"
`include "relu.v"

`define w_data 2       // 3-bit weight [2:0]
`define b_data 22      // 23-bit bias [22:0]
`define i_data 11      // 12-bit input [11:0]
`define o_data 22      // 23-bit output [22:0]

module neuron(
    input [`i_data:0] in_data,  // 12-bit input
    input clk, rst,
    output reg [`o_data:0] out_data  // 23-bit output
);
    
    reg [`w_data:0] weight_in[2:0];  // 3-bit weights, 3 of them
    reg [`b_data:0] bias_in[0:0];    // 23-bit bias
    reg [2:0] counter;               // 3-bit counter (0-4)
    wire [`o_data:0] result;         // 23-bit multiplication result
    wire [`o_data:0] out;            // 23-bit ReLU output
    wire [`o_data:0] add_result;     // 23-bit addition result
    reg [`o_data:0] num1;            // 23-bit operand for adder
    reg [`o_data:0] num2;            // 23-bit operand for adder
    reg accumulate_flag;             // Flag for proper accumulation logic

    // Register to hold accumulated sum
    reg [`o_data:0] sum;             // 23-bit sum

    // Instantiate the multiplier
    binary_fraction_multiplier mut (
        .num1(in_data),
        .num2(weight_in[counter]),
        .result(result)
    );

    // Instantiate the adder
    fp_sum sut(
        .num1(num1),
        .num2(num2),
        .result(add_result),
        .counter(counter)
    );

    // Instantiate the ReLU activation function
    relu rut(
        .data_in(sum),
        .data_out(out)
    );
    
    // Load weights and biases from memory files
    initial begin
        $readmemb("w.mif", weight_in);
        $readmemb("b.mif", bias_in);
        $display("%b", weight_in[0]);    
        $display("%b", bias_in[0]);
    end

    // Main state machine - positive clock edge
    always @(posedge clk or posedge rst) begin
        if (rst) begin  
            counter <= 3'b0;           
            num1 <= 23'b0;
            num2 <= 23'b0;
            out_data <= 23'b0;
            sum <= 23'b0;
            accumulate_flag <= 1'b0;
        end
        else begin
            if (counter == 0 && !accumulate_flag) begin
                // Initialize with bias at the start
                
                num1 <= bias_in[0];
                num2 <= result;  // First weight*input product
                accumulate_flag <= 1'b1;
                counter <= counter + 1'b1;
            end
            else if (counter < 3) begin  // Process weights 0-2

                num1 <= add_result;  // Previous accumulated sum
                num2 <= result;      // Current weight*input product
                counter <= counter + 1'b1;
            end
            else if (counter == 3) begin
                // Final calculation done, apply ReLU
                sum <= add_result;
                counter <= counter + 1'b1;
            end
            else if (counter == 4) begin
                // Output ready
                out_data <= out;
                $display("%b output by relu",out_data); //00000110111111111010110
                counter <= counter;  // Stay in this state until reset
            end
        end
    end

endmodule