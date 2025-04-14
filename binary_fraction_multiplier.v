module binary_fraction_multiplier (
    input wire [11:0] num1,        // 1-sign, 2-int, 9-fraction
    input wire [11:0] num2,        // 1-sign, 9-int, 2-fraction
    output wire [22:0] result      // 1-sign, 11-int, 11-fraction
);

    // Extract sign bits
    wire sign1 = num1[11];
    wire sign2 = num2[11];
    
    // Result sign (XOR of input signs)
    wire result_sign = sign1 ^ sign2;
    
    // Extract unsigned parts of numbers
    wire [1:0] int1 = num1[10:9];
    wire [8:0] frac1 = num1[8:0];
    
    wire [8:0] int2 = num2[10:2];
    wire [1:0] frac2 = num2[1:0];
    
    // Combine integer and fractional parts for full multiplication
    wire [10:0] unsigned_val1 = {int1, frac1};  // 2-bit int + 9-bit frac = 11 bits
    wire [10:0] unsigned_val2 = {int2, frac2};  // 9-bit int + 2-bit frac = 11 bits
    
    // Perform multiplication (result will be 22 bits)
    wire [21:0] product = unsigned_val1 * unsigned_val2;
    
    // The decimal point in the result will be positioned after 11 bits from right
    // For num1: Decimal point after 9 bits from right
    // For num2: Decimal point after 2 bits from right
    // For product: Decimal point after (9+2=11) bits from right
    
    // Combine final result: sign + product
    assign result = {result_sign, product};

endmodule

