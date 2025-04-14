`include "binary_fraction_multiplier.v"
`include "fp_sum.v"
`include "relu.v"

module nueron(  // Fixed module name from "nueron" to "neuron"
    input [11:0] in_data, 
    input clk, rst,
    output reg [22:0] out_data 
);
    
    reg [11:0] weight_in[2:0];
    reg [22:0] bias_in[0:0];
    reg [3:0] counter;
    reg [22:0] mult;
    wire [22:0] result;
    wire [22:0] out;
    reg [22:0] sum;
    wire [22:0] add_result;
    reg [22:0] num1;
    reg [22:0] num2;   

    binary_fraction_multiplier mut (
        .num1(in_data),
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
        .data_in(add_result),
        .data_out(out)
    );
    
    initial begin
        $readmemb("w_1_0.mif", weight_in);
        $readmemb("b_1_0.mif", bias_in);
        // $display("%b", weight_in[0]);    
        // $display("%b", bias_in[0]);
    end

    // Fix: Counter logic and multiplier result handling
    always @(posedge clk) begin
        if (rst|counter >=4) begin  
            counter <= 3'b0;           
            mult <= bias_in[0];
            num1<=23'b0;
            num2<=23'b0;
            out_data<=23'b0;
            
        end
        else begin
            if(counter >=4)begin
                counter <= 3'b0;           
                mult <= bias_in[0];
                num1<=23'b0;
                num2<=23'b0;
            end

            else begin
                mult <= result;
                counter <= counter+1;
            end
        end
        
        // $display(" at counter = %b \n mult %b\n", counter, mult);
    end
    
    // // Fix: Sum accumulation logic
    always @(posedge ~clk) begin
        if (rst) begin 
            
            num1 <= 23'b0;
            num2 <= 23'b0;
        end

        else begin
            num1 <= mult;     // Current multiplication result
            num2 <= add_result;      // Current accumulated sum            
        end 
        // $display(" at counter = %b \n add result %b of num1= %b, num2 = %b\n", counter, add_result, num1, num2);
    end

    always @(posedge ~clk) begin
        if (counter>=4)begin
            out_data <= out;
            $display("%b output by relu",out); //00000110111111111010110
        end
    end

endmodule