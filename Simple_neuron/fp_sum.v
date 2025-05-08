`timescale 1ns / 1ps


`define data 22

module fp_sum(
    input wire [`data:0] num1,
    input wire [`data:0] num2,
    output wire [`data:0] result,
    input wire [2:0] counter
);
    // wire [22:0] signed_num1 = num1;
    // wire [22:0] signed_num2 = num2;
    reg sign;
    reg [`data-1:0] signed_result;  // Changed to reg for use in always block

    // Procedural blocks must be in always blocks, not raw if statements
    always @(*) begin
        
      
            if (num1[`data] == num2[`data]) begin
                signed_result = $signed(num1) + $signed(num2);
                sign = num1[`data];
            end
            else if (num2[`data-1:0] >= num1[`data-1:0]) begin
                signed_result = $signed(num2) - $signed(num1);
                sign = num2[`data];
            end
            else begin
                signed_result = $signed(num1) - $signed(num2);
                sign = num1[`data];
            end
        end
    

    assign result = {sign, signed_result};

endmodule



