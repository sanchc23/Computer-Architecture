module BitCell (Bitline1, Bitline2, clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2);
input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
inout Bitline1, Bitline2;

wire Q;

dff ff_1(.q(Q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

assign Bitline1 = ReadEnable1 ? Q : 1'bZ;
assign Bitline2 = ReadEnable2 ? Q : 1'bZ;


endmodule