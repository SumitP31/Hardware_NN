`timescale 1ns / 1ps

module nueron_tb();
    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Testbench signals
    reg [11:0] in_data;
    reg clk, rst;
    wire [22:0] out_data;
    
    // Instantiate the Unit Under Test (UUT)
    nueron uut (
        .in_data(in_data),
        .clk(clk),
        .rst(rst),
        .out_data(out_data)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        in_data = 12'b0;
        rst = 1;
        
        // Wait for a few clock cycles
        #(CLK_PERIOD*2);
        
        // Release reset
        rst = 0;
        
        // Apply test vectors
        // Test case 1: Positive input
        in_data = 12'b1011100; // +10 in 12-bit signed
        #(CLK_PERIOD); // Wait for 4 cycles to process
        
        // Test case 2: Negative input
        in_data = 12'b11100100; // -10 in 12-bit signed
        #(CLK_PERIOD);
        
        // Test case 3: Maximum positive value
        in_data = 12'b111000000; // +2047 in 12-bit signed
        #(CLK_PERIOD);
        
        // Test case 4: Maximum negative value
        in_data = 12'b1011100; // -2048 in 12-bit signed
        #(CLK_PERIOD);
        
        // Test case 5: Zero
        in_data = 12'b1011100; // 0
        #(CLK_PERIOD);
        
        // Test reset during operation
        in_data = 12'b1011100; // +15
        #(CLK_PERIOD);
        // rst = 1;
        #(CLK_PERIOD);
        // rst = 0;
        #(CLK_PERIOD*4);
        
        // Finish simulation
        #(CLK_PERIOD*2);
        $display("Simulation completed");
        $finish;
    end
    
    // // Monitor signals
    // initial begin
    //     $monitor("Time=%0t | rst=%b | in_data=%b (%d) | counter=%b | out=%b (%d) | out_data=%b",
    //              $time, rst, in_data, $signed(in_data), uut.counter, out_data);
    // end
    
    // Create VCD file for waveform viewing
    initial begin
        $dumpfile("nueron_tb.vcd");
        $dumpvars(0, nueron_tb);
    end
    
endmodule