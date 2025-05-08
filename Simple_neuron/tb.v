`timescale 1ns / 1ps
`include "neuron.v"

`define w_data 2       // Weight data width
`define b_data 22      // Bias data width (matches neuron implementation)
`define i_data 11      // Input data width
`define o_data 22      // Output data width (matches neuron implementation)

module neuron_tb();
    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Testbench signals
    reg [`i_data:0] in_data;    // 12-bit input [11:0]
    reg clk, rst;
    wire [`o_data:0] out_data;  // 23-bit output [22:0]
    
    // Instantiate the Unit Under Test (UUT)
    neuron uut (
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
        in_data = 12'b000000000000;  // Initialize with all zeros
        rst = 1;
        
        // Wait for a few clock cycles with reset active
        #(CLK_PERIOD*2);
        
        // Release reset
        rst = 0;
        #(CLK_PERIOD);
        
        // Apply test vectors - allowing sufficient time for processing
        
        // Test case 1: Small positive input with sign bit 0
        in_data = 12'b001000000000; // +1.75 (0 sign, 001 int, 011100000 frac)
        #(CLK_PERIOD*5); // Wait for 5 cycles to complete processing
        
        // Test case 2: Small negative input with sign bit 1
        in_data = 12'b001000000000; // -1.75 (1 sign, 001 int, 011100000 frac)
        #(CLK_PERIOD*5);
        
        // Test case 3: Larger positive value
        in_data = 12'b001000000000; // +7.0 (0 sign, 111 int, 000000000 frac)
        #(CLK_PERIOD*5);
        
        // Test case 4: Another value for testing
        in_data = 12'b001000000000; // +0.375 (0 sign, 000 int, 001100000 frac)
        #(CLK_PERIOD*5);
        
        // Test case 5: Zero
        in_data = 12'b001000000000; // 0.0
        #(CLK_PERIOD*5);
        
        // Test reset during operation
        in_data = 12'b010000000000; // +4.0
        #(CLK_PERIOD*2);
        rst = 1;
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD*5);
        
        // Finish simulation
        #(CLK_PERIOD*2);
        $display("Simulation completed");
        $finish;
    end
    
    // Monitor signals (uncomment for debugging)
    // initial begin
    //     $monitor("Time=%0t | rst=%b | in_data=%b | counter=%d | out_data=%b",
    //              $time, rst, in_data, uut.counter, out_data);
    // end
    
    // Create VCD file for waveform viewing
    // initial begin
    //     $dumpfile("neuron_tb.vcd");
    //     $dumpvars(0, neuron_tb);
    // end
    
endmodule