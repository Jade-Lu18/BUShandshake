`timescale 1ns/1ns
module testbench;
reg clk_tb;
reg [31:0] transmit_data_tb;
reg reset_tb;

wire valid_tb;
wire [31:0] data_tb;
wire valid_tb;
wire response_tb;

parameter CLK_HALF_PERIOD1 = 5;
parameter RESET_DELAY = 100;

initial begin
 clk_tb = 0;
end

always #CLK_HALF_PERIOD1 clk_tb = ~clk_tb;

initial begin

 reset_tb = 0;
 #RESET_DELAY reset_tb = 1;

end

initial begin
 #500;
 transmit_data_tb = 32'h20220501;
end

master master_test
 (.clk(clk_tb),
 .reset(reset_tb),
 .ready(ready_tb),
 .response(response_tb),
 .data(transmit_data_tb),
 .dout(data_tb),
 .valid(valid_tb));
 
slave slave_test
 (.clk(clk_tb),
 .reset(reset_tb),
 .valid(ready_tb),
 .data(data_tb),
 .ready(ready_tb),
 .response(response_tb));
endmodule
