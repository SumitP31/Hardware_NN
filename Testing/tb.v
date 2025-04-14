`timescale 1ns/1ps

module fixed_point_mac_tb;
    // Testbench signals
    reg clk;
    reg rst;
    reg [11:0] multiplicand;
    reg valid_in;
    wire valid_out;
    wire [22:0] result;
    
    // Instantiate the unit under test (UUT)
    nueron uut(
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .valid_in(valid_in),
        .valid_out(valid_out),
        .result(result)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Test sequence
    initial begin
        // Initialize
        rst = 1;
        valid_in = 0;
        multiplicand = 0;
        
        // Reset pulse
        #20;
        rst = 0;
        #10;
        
        // Test case: Three multiplications followed by accumulation
        // Assuming 8.8 fixed-point format (8 bits integer, 8 bits fraction)
        
        // First multiplication
        multiplicand = 12'b1011100; // 1.0 in fixed point   // 2.0 in fixed point
        valid_in = 1;
        #10;
        
        // Second multiplication
        multiplicand = 12'b11100100; // 1.5 in fixed point
          // 3.0 in fixed point
        #10;
        
        // Third multiplication
        multiplicand = 12'b111000000; // 2.0 in fixed point
        // 4.0 in fixed point
        #10;
        
        // Stop providing input
        valid_in = 0;
        
        // Wait to see result
        #20;
        
        // // Expected result: 1.0*2.0 + 1.5*3.0 + 2.0*4.0 = 2.0 + 4.5 + 8.0 = 14.5
        // if (valid_out) begin
        //     $display("Result: %h (Expected ~14.5)", result);
        //     if (result == 32'h00000E80) // 14.5 in 16.16 fixed point
        //         $display("Test PASSED");
        //     else
        //         $display("Test FAILED");
        // end else begin
        //     $display("Output not valid at expected time");
        // end
        
        // // Run another set
        // #10;
        // // First multiplication
        // multiplicand = 16'h0080; // 0.5 in fixed point
        // multiplier = 16'h0080;   // 0.5 in fixed point
        // valid_in = 1;
        // #10;
        
        // // Second multiplication
        // multiplicand = 16'h0040; // 0.25 in fixed point
        // multiplier = 16'h0040;   // 0.25 in fixed point
        // #10;
        
        // // Third multiplication
        // multiplicand = 16'h0020; // 0.125 in fixed point
        // multiplier = 16'h0020;   // 0.125 in fixed point
        // #10;
        
        // // Stop providing input
        valid_in = 0;
        
        // Wait to see result
        #20;
        
        // // Expected result: 0.5*0.5 + 0.25*0.25 + 0.125*0.125 = 0.25 + 0.0625 + 0.015625 = 0.328125
        // if (valid_out) begin
        //     $display("Result: %h (Expected ~0.328125)", result);
        //     if (result == 32'h00000054) // 0.328125 in 16.16 fixed point
        //         $display("Test PASSED");
        //     else
        //         $display("Test FAILED");
        // end else begin
        //     $display("Output not valid at expected time");
        // end
        
        #100 $finish;
    end
    
    // Monitor signals
    // initial begin
    //     $monitor("Time=%0t: valid_in=%b, multiplicand=%h, multiplier=%h, counter=%0d, valid_out=%b, result=%h",
    //              $time, valid_in, multiplicand, multiplier, uut.counter, valid_out, result);
    // end

endmodule