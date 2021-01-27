module PC(clk, rst, PC_In, PC_Out, PC_en);
// Turns out PC needs to be a register. My God are we dumb

input wire clk, rst, PC_en;
input wire[15:0] PC_In;
output wire[15:0] PC_Out;

dff ff[15:0](.q(PC_Out), .d(PC_In), .wen(PC_en), .clk(clk), .rst(rst));


endmodule
