`define data 11

module fixed_point_adder (
    input  signed [`data:0] a,  // Q5.6 signed fixed-point number
    input  signed [`data:0] b,  // Q5.6 signed fixed-point number
    output signed [`data+1:0] sum // Output is 13 bits to handle overflow
);

    assign sum = a + b;

endmodule