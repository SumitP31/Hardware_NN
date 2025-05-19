`include "neuron.v"

`define in_data 11
`define out_data 22


module layer(
    input rst,
    input clk,
    input [`in_data:0] in_data_0,
    input [`in_data:0] in_data_1,
    input [`in_data:0] in_data_2,

    output reg [`out_data:0] out_data
);
    // reg [`in_data:0] in_data[2:0];
    wire [`out_data:0] out_n1;
    wire [`out_data:0] out_n2;
    wire [`out_data:0] out_n3;
    wire [`out_data:0] out_n4;
    wire [`out_data:0] out_n5;
    wire out_valid_1;
    wire out_valid_2;
    wire out_valid_3;
    wire out_valid_4;
    wire out_valid_5;


//     always @(*) begin
//     inputs[0] <= input0;
//     inputs[1] <= input1;
//     inputs[2] <= input2;
//     inputs[3] <= input3;
// end
    
    neuron #(.NEURON_ID(0)) n1(
        .in_data_0(in_data_0),
        .in_data_1(in_data_1),
        .in_data_2(in_data_2),
        .rst(rst), .clk(clk), 
        .out_data(out_n1),
        .out_valid(out_valid_1)
        );

    neuron #(.NEURON_ID(1)) n2(
        .in_data_0(in_data_0),
        .in_data_1(in_data_1),
        .in_data_2(in_data_2),
        .rst(rst), .clk(clk), 
        .out_data(out_n2),
        .out_valid(out_valid_2)
        );

    neuron #(.NEURON_ID(2)) n3(
        .in_data_0(in_data_0),
        .in_data_1(in_data_1),
        .in_data_2(in_data_2),
        .rst(rst), .clk(clk), 
        .out_data(out_n3),
        .out_valid(out_valid_3)
        );

    neuron #(.NEURON_ID(3)) n4(
        .in_data_0(in_data_0),
        .in_data_1(in_data_1),
        .in_data_2(in_data_2), 
        .rst(rst), .clk(clk), 
        .out_data(out_n4),
        .out_valid(out_valid_4)
        );

    neuron #(.NEURON_ID(4)) n5(
        .in_data_0(in_data_0),
        .in_data_1(in_data_1),
        .in_data_2(in_data_2), 
        .rst(rst), .clk(clk), 
        .out_data(out_n5),
        .out_valid(out_valid_5)
        );


    always @(posedge clk or rst ) begin

        if (rst) begin
            out_data<=`out_data'b0;
        end

        else if(out_valid_1 == 1 && out_valid_2 == 1 && out_valid_3 == 1 && out_valid_4 == 1) begin
            out_data = out_n1;

            if (out_n2 > out_data)
                out_data = out_n2;
            if (out_n3 > out_data)
                out_data = out_n3;
            if (out_n4 > out_data)
                out_data = out_n4;
            $display("output %b", out_data);
            $display("output_1 = %b \toutput_2= %b \noutput_3 = %b \toutput_4 = %b \n output_5 = %b", out_n1, out_n2, out_n3, out_n4, out_n5 ); 
        end
        // $display("output_1 = %b \toutput_2= %b \toutput_3 = %b \toutput_4 = %b \t", out_n1, out_n2, out_n3, out_n4 );    
        // $display("output %b", out_data);
    end


endmodule