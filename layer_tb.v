`timescale 1ns / 1ps
`include "layer.v"

module layer_tb();
    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Testbench signals
    reg [11:0] in_data[2:0];
    reg clk, rst;
    wire [22:0] out_data;
    
    // Instantiate the Unit Under Test (UUT)
    layer uut (
        .in_data_0(in_data[0]),
        .in_data_1(in_data[1]),
        .in_data_2(in_data[2]),        
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
        in_data[0] = 12'b0;
        in_data[1] = 12'b0;
        in_data[2] = 12'b0;
        rst = 1;
        
        // Wait for a few clock cycles
        #(CLK_PERIOD*2);
        
        // Release reset
        rst = 0;
        
        // Apply test vectors
        // Test case 1: Positive input
        in_data[0] = 12'b101000; // 10
        // #(CLK_PERIOD); // Wait 1 clock cycles
        
        // Test case 2: Negative input
        in_data[1] = 12'b101000; // 10
        // #(CLK_PERIOD);
        
        // Test case 3: Maximum positive value
        in_data[2] = 12'b101000; // 10
        #(CLK_PERIOD*8);

        // $display("%b output by relu",out_data);

        // Test case 4: Maximum negative value
        // in_data = 12'b1011100; // 23
        // #(CLK_PERIOD);
        
        // // Test case 5: Zero
        // in_data = 12'b1011100; // 23
        // #(CLK_PERIOD);
        // // Test reset during operation
        // in_data = 12'b100100001000; // -66
        // #(CLK_PERIOD);
        // rst = 1;
        // #(CLK_PERIOD);
        // rst = 0;
        // #(CLK_PERIOD*4);
        
        // Finish simulation
        // #(CLK_PERIOD*2);
        $display("Simulation completed");
        // $display("%b output by relu",out_data);
        $finish;
    end
    
    // Monitor signals
    // initial begin
    //     $monitor("Time=%0t | rst=%b | in_data=%b (%d) | counter=%b | out=%b (%d) | out_data=%b",
    //              $time, rst, in_data, $signed(in_data), uut.counter, out_data);
    // end
    
    // Create VCD file for waveform viewing
    // initial begin
    //     $dumpfile("nueron_tb.vcd");
    //     $dumpvars(0, nueron_tb);
    // end
    
endmodule