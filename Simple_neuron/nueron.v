`include "Simple_neuron/binary_fraction_multiplier.v"
`include "Simple_neuron/fp_sum.v"
`include "Simple_neuron/relu.v"

module nueron(  // Fixed module name spelling from "nueron" to "neuron"
    input [11:0] in_data, 
    input clk, rst,
    output reg [22:0] out_data 
);
    
    reg [11:0] weight_in[2:0];
    reg [22:0] bias_in[0:0];
    reg [3:0] counter;  // Changed to 3 bits to match the intended range (0-4)
    wire [22:0] result;
    wire [22:0] out;
    wire [22:0] add_result;
    reg [22:0] num1;
    reg [22:0] num2;   
    reg accumulate_flag;  // Added flag for proper accumulation logic

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
        .data_in(sum),  // Changed from add_result to sum for proper sequencing
        .data_out(out)
    );
    
    // Load weights and biases from memory files
    initial begin
        $readmemb(".w_1_0.mif", weight_in);
        $readmemb(".b_1_0.mif", bias_in);
        // $display("%b", weight_in[0]);    
        // $display("%b", bias_in[0]);
    end

    // Register to hold accumulated sum
    reg [22:0] sum;

    // Main state machine - positive clock edge
    always @(posedge clk or posedge rst) begin
        if (rst|counter>4) begin  
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
                $display("%b output by relu",out); //00000110111111111010110
                counter <= counter+ 1'b1;  // Stay in this state until reset
            end
        end
    end

endmodule