`timescale 1ns / 1ps

module fp_sum(
    input wire [22:0] num1,
    input wire [22:0] num2,
    output wire [22:0] result,
    input wire [3:0] counter
);
    // wire [22:0] signed_num1 = num1;
    // wire [22:0] signed_num2 = num2;
    reg sign;
    reg [21:0] signed_result;  // Changed to reg for use in always block

    // Procedural blocks must be in always blocks, not raw if statements
    always @(*) begin
        
      
            if (num1[22] == num2[22]) begin
                signed_result = $signed(num1) + $signed(num2);
                sign = num1[22];
            end
            else if (num2[21:0] >= num1[21:0]) begin
                signed_result = $signed(num2) - $signed(num1);
                sign = num2[22];
            end
            else begin
                signed_result = $signed(num1) - $signed(num2);
                sign = num1[22];
            end
        end
    

    assign result = {sign, signed_result};

endmodule

