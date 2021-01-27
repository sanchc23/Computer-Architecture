//Tag Array of 128  blocks
//Each block will have 1 byte
//BlockEnable is one-hot
//WriteEnable is one on writes and zero on reads


module MetaDataArray(clk, rst, DataIn, Write0, Write1, BlockEnable, DataOut0, DataOut1);
	input wire clk, rst, Write0, Write1;
	input wire[7:0] DataIn;		// {lru | valid | tag}
	input wire[63:0] BlockEnable;	// set select from cache_control
	output wire[7:0] DataOut0, DataOut1;  // Output both tags and check at control level for hit
	wire valid, lru;

	// Test
	// .valid(valid)
	assign valid = (Write0 | Write1);

	// lru enable goes high if we see an valid or write. Only if it's enabled will it flip tho
	assign lru = (DataIn[7] | DataIn[6]) & (Write0 | Write1);
	

	// The 2 - 64 Mblks represent a 2 way cache w/ 64 sets
	MBlock Mblk0[63:0]( .clk(clk), .rst(rst), .Din(DataIn[5:0]), .WriteEnable(Write0), .Enable(BlockEnable), .Dout(DataOut0), .LruEnable(lru), .valid(Write0));
	MBlock Mblk1[63:0]( .clk(clk), .rst(rst), .Din(DataIn[5:0]), .WriteEnable(Write1), .Enable(BlockEnable), .Dout(DataOut1), .LruEnable(lru), .valid(Write1));
endmodule





// TODO FIX FOR LRU
module MBlock( input clk,  input rst, input [5:0] Din, input WriteEnable, input Enable, input valid, output [7:0] Dout, input LruEnable);

	// If we don't write to this LRU then that means that it is old so update 
	MCell LRU( .clk(clk), .rst(rst), .Din(~WriteEnable), .WriteEnable(LruEnable), .Enable(Enable), .Dout(Dout[7]));

	// once we use have a write this will always be valid so slap a 1 in it and keep it that way
	MCell valid0( .clk(clk), .rst(rst), .Din(1'b1), .WriteEnable(WriteEnable & valid), .Enable(Enable), .Dout(Dout[6]));
	MCell mc[5:0]( .clk(clk), .rst(rst), .Din(Din[5:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[5:0]));
endmodule

module MCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~WriteEnable) ? q:'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule
