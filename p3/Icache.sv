module Icache(clk, rst, data_wrt_en, tag_wrt_en, way0, way1, Tag_In, Data_In, blk_en, word_enable, tag_out0, tag_out1, data_out0, data_out1);
input wire clk, rst, data_wrt_en, tag_wrt_en;
input wire way0, way1;	// way selects
input wire[7:0] Tag_In, word_enable;
input wire[15:0] Data_In;
input wire[63:0] blk_en;
output wire[7:0] tag_out1, tag_out0;	//tag stored at accessed point
output wire[15:0] data_out0, data_out1;


// 1 cycle write of 2 bytes
// 4 cycle read of 2 bytes

// BlockEnable selects the Set
// WordEnable uses offset to select the work in the cache block
DataArray data(.clk(clk), .rst(rst), .DataIn(Data_In), .Write0(data_wrt_en & way0), .Write1(data_wrt_en & way0),
	.BlockEnable(blk_en), .WordEnable(word_enable), .DataOut0(data_out0), .DataOut1(data_out1));

// Tag array
// LRU, valid, tag
// |1 bit | 1 bit| 6 bits|
MetaDataArray set1(.clk(clk), .rst(rst), .DataIn(Tag_In), .Write0(tag_wrt_en & way0), .Write1(tag_wrt_en & way1), .BlockEnable(blk_en),
	.DataOut0(tag_out0), .DataOut1(tag_out1));


endmodule

