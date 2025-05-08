module relu(
    input [22:0] data_in,      // Input data (signed)
    output [22:0] data_out     // Output data after ReLU
);
    // ReLU function: f(x) = max(0, x)
    assign data_out = (data_in[22]) ? 22'd0 : data_in;
    // If the MSB (sign bit) is 1 (negative), output 0
    // Otherwise, pass the input value as is

endmodule