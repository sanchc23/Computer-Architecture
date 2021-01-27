module Register(Bitline1, Bitline2, clk, rst, D, WriteReg, ReadEnable1, ReadEnable2);
input clk, rst, WriteReg, ReadEnable1, ReadEnable2;
input [15:0] D;
inout [15:0] Bitline1, Bitline2;

// A register is just 16 bit cells so instanciate 16 bitcells and connect the wires
	BitCell bc[15:0](.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2)); 

endmodule