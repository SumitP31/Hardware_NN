//`include "Simple_neuron/binary_fraction_multiplier.v"
//`include "Simple_neuron/fp_sum.v"
//`include "Simple_neuron/relu.v"

`define IN_WIDTH     12
`define OUT_WIDTH    23
`define NUM_WEIGHTS  5

module neuron #(parameter NEURON_ID = 0)(
    input [`IN_WIDTH-1:0] in_data_0,
    input [`IN_WIDTH-1:0] in_data_1,
    input [`IN_WIDTH-1:0] in_data_2,
    input [`IN_WIDTH-1:0] in_data_3, 
    input clk, rst,
    output reg [`OUT_WIDTH-1:0] out_data,
    output reg out_valid
);

    reg [`IN_WIDTH-1:0] weight_in[`NUM_WEIGHTS-1:0];
    reg [`OUT_WIDTH-1:0] bias_in[0:0];

    reg [3:0] counter;

    wire [`OUT_WIDTH-1:0] result;
    wire [`OUT_WIDTH-1:0] out;
    wire [`OUT_WIDTH-1:0] add_result;
    reg [`OUT_WIDTH-1:0] num1, num2, sum;
    reg accumulate_flag;

    reg [`IN_WIDTH-1:0] in_data[`NUM_WEIGHTS-1:0];

    always @(*) begin
        in_data[0] <= in_data_0;
        in_data[1] <= in_data_1;
        in_data[2] <= in_data_2;
    end

    // Instantiations
    binary_fraction_multiplier mut (
        .num1(in_data[counter]),
        .num2(weight_in[counter]),
        .result(result)
    );

    fp_sum sut(
        .num1(num1),
        .num2(num2),
        .result(add_result),
        .counter(counter)
    );

    relu rut(
        .data_in(sum),
        .data_out(out)
    );

    // Load weights and bias
    initial begin
        if(NEURON_ID==0) begin
            $readmemb(".w_1_0.mif", weight_in);
            $readmemb(".b_1_0.mif", bias_in);
            
        end else if(NEURON_ID==1) begin
            $readmemb(".w_1_1.mif", weight_in);
            $readmemb(".b_1_1.mif", bias_in);
            
        end else if(NEURON_ID==2) begin
            $readmemb(".w_1_2.mif", weight_in);
            $readmemb(".b_1_2.mif", bias_in);

        end else if(NEURON_ID==3) begin
            $readmemb(".w_1_3.mif", weight_in);
            $readmemb(".b_1_3.mif", bias_in);

        end else if(NEURON_ID==4) begin
            $readmemb(".w_1_3.mif", weight_in);
            $readmemb(".b_1_3.mif", bias_in);

        end else begin        
            $fatal("NEURON ID not defined!");
        end

        // $display("weights := %b", weight_in[0]);    
        // $display("biase := %b", bias_in[0]);

    end


always @(posedge clk) begin
        if (rst|counter>4) begin  
            counter <= 3'b0;           
            num1 <= 23'b0;
            num2 <= 23'b0;
            out_data <= 23'b0;
            sum <= 23'b0;
            accumulate_flag <= 1'b0;
            out_valid <= 1'b0;
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
                out_valid = 1'b1;
                // $display("%b output by relu",out); //00000110111111111010110
                counter <= counter+ 1'b1;  // Stay in this state until reset
            end
        end
    end

endmodule
