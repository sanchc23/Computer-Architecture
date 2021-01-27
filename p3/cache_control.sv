module cache_control(clk, rst, if_stall, mem_stall, instr_read, instr_write, data_write, data_read, instr_cache_addr, data_cache_addr, data_cache_in, instr_data_out, data_data_out);
input wire clk, rst;
input wire instr_read, instr_write, data_write, data_read;	// wether a write or read occurs for the 2 caches
input wire[15:0] instr_cache_addr, data_cache_addr;  // address for icache and dcahce
input wire[15:0] data_cache_in;       		     // data
 
output wire if_stall, mem_stall;
output wire[15:0] instr_data_out, data_data_out;	// data output for cache controller

wire dmiss, imiss, fm_stall;  // internal stall and miss signals
wire cache_en;
wire data_mem_valid;	// used by mem and fsm to say life is good
wire[15:0] instr_cache_out, data_cache_out;	// outputs of the cache modules

wire[15:0] mem_data_in, mem_data_out;	// input and output for memory module

wire write_data_array, write_tag_array;	// enable for cache write from FSM


wire instr_write_0, instr_write_1, data_write_0, data_write_1;
wire i_write_way0, i_write_way1, d_write_way0, d_write_way1;
wire way_0, way_1;
wire [7:0] instr_tagarray0, instr_tagarray1, data_tagarray0, data_tagarray1;
wire [7:0] instr_tagarray_0_out, instr_tagarray_1_out, data_tagarray_0_out, data_tagarray_1_out;
wire [7:0] instr_cache_wordEn, data_cache_wordEn, word_sel, instr_cache_word_sel, data_cache_word_sel;
wire [63:0] instr_blockEnable, data_blockEn;
wire [15:0] instr_cache_write, data_cache_write;
wire [15:0] instr_cache_data_out0, instr_cache_data_out1, data_cache_data_out0, data_cache_data_out1;
wire [15:0] memory_data_out, memory_address, miss_address;
wire[15:0] data_cache_data_in;

//6 to 64 decoder for index bits
ReadDecoder_6_64 instr_index(.RegId(instr_cache_addr[9:4]), .Wordline(instr_blockEnable));
ReadDecoder_6_64 data_index(.RegId(data_cache_addr[9:4]), .Wordline(data_blockEn));

//3 to 8 decoder for word select
WordEnable_3_8 instr_offset(.RegId(instr_cache_addr[3:1]), .Wordline(instr_cache_wordEn));
WordEnable_3_8 data_offset(.RegId(data_cache_addr[3:1]), .Wordline(data_cache_wordEn));

dff instr_tagarray_0[7:0](.q(instr_tagarray_0_out), .d(instr_tagarray0), .wen(1'b1), .clk(clk), .rst(rst));
dff instr_tagarray_1[7:0](.q(instr_tagarray_1_out), .d(instr_tagarray1), .wen(1'b1), .clk(clk), .rst(rst));
dff data_tagarray_0[7:0](.q(data_tagarray_0_out), .d(data_tagarray0), .wen(1'b1), .clk(clk), .rst(rst));
dff data_tagarray_1[7:0](.q(data_tagarray_1_out), .d(data_tagarray1), .wen(1'b1), .clk(clk), .rst(rst));


assign cache_enable = (instr_write | instr_read | data_write | data_read);
//instruction cache
//
Icache icache(.clk(clk), .rst(rst), .data_wrt_en(FSM_Wen | instr_write), .tag_wrt_en(FSM_tag_Wen), .way0(instr_write_0 | i_write_way0), .way1(instr_write_1 | i_write_way1),
                .word_enable(instr_cache_word_sel), .Tag_In({instr_read, instr_write,instr_cache_addr[15:10]}), .Data_In(instr_cache_write), .blk_en(instr_blockEnable), .tag_out0(instr_tagarray0),
                .tag_out1(instr_tagarray1), .data_out0(instr_cache_data_out0), .data_out1(instr_cache_data_out1));

//data cache
Icache dcache(.clk(clk), .rst(rst), .data_wrt_en(FSM_Wen | data_write), .tag_wrt_en(FSM_tag_Wen), .way0(data_write_0 | d_write_way0), .way1(data_write_1 | d_write_way1),
                .word_enable(data_cache_word_sel), .Tag_In({data_read, data_write,data_cache_addr[15:10]}), .Data_In(data_cache_write), .blk_en(data_blockEn), .tag_out0(data_tagarray0),
                .tag_out1(data_tagarray1), .data_out0(data_cache_data_out0), .data_out1(data_cache_data_out1));

//state machine to handle cache misses
cache_fill_FSM FSM(.clk(clk), .rst(rst), .miss_detected(cache_enable & (instr_miss_detected | data_miss_detected)), .way_0(way_0), .way_1(way_1), .miss_address(miss_address), .fsm_busy(stall), .write_data_array(FSM_Wen),
                .write_tag_array(FSM_tag_Wen), .memory_address(memory_address), .memory_data_valid(data_valid_memory), .word_select(word_sel));


wire test_way0, test_way1, test_fsm_b, test_FSM_cache_Wen, test_FSM_tag_Wen;
wire [15:0] test_memory_address;
wire [7:0] test_word_sel;

// data_in is our cache_input since we never write a instruction
 
memory4c memory(.data_out(memory_data_out), .data_in(data_cache_in), .addr(memory_address), .enable(instr_miss_detected | data_miss_detected), .wr(~stall & data_write), .clk(clk), .rst(rst), .data_valid(data_valid_memory));


//if our tags and cache addr match and there is a valid bit and we are not writing to the tag the we can hit 
assign instr_write_0 = (instr_cache_addr[15:10] == instr_tagarray0[5:0] & instr_tagarray0[6]) & ~FSM_tag_Wen;
assign instr_write_1 = (instr_cache_addr[15:10] == instr_tagarray1[5:0] & instr_tagarray1[6]) & ~FSM_tag_Wen;
assign data_write_0 = (data_cache_addr[15:10] == data_tagarray0[5:0] & data_tagarray0[6]) & ~FSM_tag_Wen;
assign data_write_1 = (data_cache_addr[15:10] == data_tagarray1[5:0] & data_tagarray1[6]) & ~FSM_tag_Wen;

// if there was a miss in both ways and we were supposed to read or write
assign instr_miss_detected = (~instr_write_0 & ~instr_write_1) & (instr_write | instr_read);
assign instr_cache_hit = ~instr_miss_detected & (instr_write | instr_read) & ~FSM_tag_Wen;

assign data_miss_detected = (~data_write_0 & ~data_write_1) & (data_write | data_read);
assign data_cache_hit = ~data_miss_detected & (data_write | data_read);

//get miss address in case of cache miss
assign miss_address = instr_miss_detected ? instr_cache_addr : data_cache_addr;

//set data to be stored in cache
assign data_cache_write = data_miss_detected ? memory_data_out : data_cache_in;
assign instr_cache_write = memory_data_out;

assign instr_cache_word_sel = (~instr_miss_detected) ? instr_cache_wordEn : word_sel;
assign data_cache_word_sel = (~data_miss_detected) ? instr_cache_wordEn : word_sel;

//select the output based on the way hit
assign instr_data_out = (stall) ? 1'b0 : instr_write_1 ? instr_cache_data_out1 : instr_cache_data_out0;
assign data_data_out = (stall) ? 1'b0 : data_write_1 ? data_cache_data_out1 : data_cache_data_out0;

//stall if we get a FSM stall signal
assign if_stall = (instr_read | instr_write) & stall;
assign mem_stall = (data_read | data_write) & stall;


assign i_write_way0 = (instr_tagarray_0_out[6] == 0) ? 1'b1 : (instr_tagarray_0_out[7]);
assign i_write_way1 = (instr_tagarray_1_out[6] == 0 & ~i_write_way0) ? 1'b1 : (instr_tagarray_1_out[7]);
assign d_write_way0 = (data_tagarray_0_out[6] == 0) ? 1'b1 : (data_tagarray_0_out[7]);
assign d_write_way1 = (data_tagarray_1_out[6] == 0 & ~d_write_way0) ? 1'b1 : (data_tagarray_1_out[7]);

endmodule 
