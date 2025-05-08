`define w_data 2       // Weight data width (3 bits total: [2:0])
`define i_data 11      // Input data width (12 bits total: [11:0])
`define o_data 22     // Output data width (15 bits total: [14:0]) - CORRECTED from 11

`define int_width_w 2  // Integer width for weights
`define int_width_in 3 // Integer width for inputs

module binary_fraction_multiplier (
    input wire [`i_data:0] num1,        // 1-sign, 2-int, 9-fraction --- input (12 bits total)
    input wire [`w_data:0] num2,        // 1-sign, 1-int, 1-fraction ----- weight (3 bits total)
    output wire [`o_data:0] result      // 1-sign, 22-int+fraction bits ---- weight * input (23 bits total)
);

    // Extract sign bits
    wire sign1 = num1[`i_data]; // Input sign bit
    wire sign2 = num2[`w_data]; // Weight sign bit
    
    // Result sign (XOR of input signs)
    wire result_sign = sign1 ^ sign2;
    
    // Extract unsigned parts of numbers
    
    // For inputs - Extract integer and fractional parts
    wire [`int_width_in-1:0] int1 = num1[(`i_data-1):(`i_data-`int_width_in)]; // Integer part (3 bits)
    wire [(`i_data-`int_width_in):0] frac1 = num1[(`i_data-`int_width_in):0]; // Fractional part (9 bits)
    
    // For weights - Extract integer and fractional parts
    wire [`int_width_w-1:0] int2 = num2[(`w_data-1):(`w_data-`int_width_w)]; // Integer part (2 bits)
    wire [(`w_data-`int_width_w):0] frac2 = num2[(`w_data-`int_width_w):0]; // Fractional part (1 bit)
    
    // Combine integer and fractional parts for full multiplication
    wire [`i_data-1:0] unsigned_val1 = {int1, frac1};  // 12-bit unsigned value
    wire [`w_data-1:0] unsigned_val2 = {int2, frac2};  // 3-bit unsigned value
    
    // Perform multiplication (result will be up to 15 bits for unsigned multiplication)
    wire [(`i_data-1)+(`w_data-1)+1:0] product = unsigned_val1 * unsigned_val2; // 11+2+1=14 bits wide
    
    // The decimal point in the result will be positioned after 10 bits from right (9+1)
    // For num1: Decimal point after 9 bits from right
    // For num2: Decimal point after 1 bit from right
    // For product: Decimal point after (9+1=10) bits from right
    
    // Combine final result: sign + product
    assign result = {result_sign, product};

endmodule