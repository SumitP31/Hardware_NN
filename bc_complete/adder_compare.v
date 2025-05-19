
module adder_compare #(
    parameter CONST_VAL = 1'b0 // Example: 0.001 in your fixed-point format
)(
    input clk,
    input rst,
    input [11:0] input_array_0,
    input [11:0] input_array_1,
    input [11:0] input_array_2,
    input [11:0] input_array_3,
    input [11:0] input_array_4,
    input [11:0] input_array_5,
    input [11:0] input_array_6,
    input [11:0] input_array_7,
    input [11:0] input_array_8,
    input [12:0] bias,
    output reg out
);

    reg [11:0] inputs [8:0];
    reg [12:0] sum;
    // wire [11:0] biased;
    integer i;

    // adder stt (
    //     .num1(sum),
    //     .num2(bias),
    //     .result(biased)
    // );

    always @(posedge clk or rst) begin
        if (rst) begin
            sum <= 0;
            out <= 0;
        end else begin
            // Load inputs into array
            inputs[0] = input_array_0;
            inputs[1] = input_array_1;
            inputs[2] = input_array_2;
            inputs[3] = input_array_3;
            inputs[4] = input_array_4;
            inputs[5] = input_array_5;
            inputs[6] = input_array_6;
            inputs[7] = input_array_7;
            inputs[8] = input_array_8;

            // Sum all inputs
            sum = 0;
            for (i = 0; i < 9; i = i + 1) begin
                sum = sum + inputs[i];
                // $display("Sum: %b | Input[%0d]: %b", sum, i, inputs[i]);
            end

            $display("Sum: %b | bias: %b", sum,bias);
            // Compare sum + bias to constant
            out <= (sum > bias) ? 1'b1 : 1'b0;
        end
    end

endmodule
