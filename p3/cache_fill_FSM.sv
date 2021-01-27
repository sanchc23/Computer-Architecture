module cache_fill_FSM(clk, rst, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data_valid, way_0, way_1, word_select);

input clk, rst;
input miss_detected; // active high when tag match logic detects a miss
input [15:0] miss_address; // address that missed the cache
output reg fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
output reg write_data_array; // write enable to cache data array to signal when filling with memory_data
output reg write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
output [15:0] memory_address; // address to read from memory
input memory_data_valid; // active high indicates valid data returning on memory bus
output way_0, way_1;
output [7:0] word_select;

wire[3:0] offset_cin, offset_cout;

wire curr_state, next_state, chunks_left;
wire[3:0] curr_chunk, next_chunk;


wire [15:0] offset_address;
wire[3:0] sum, sum_off;
wire busy_in, busy_out;

dff busy(.clk(clk), .rst(rst), .wen(1'b1), .q(busy_out), .d(busy_in));
dff state(.clk(clk), .rst(rst), .wen(1'b1), .q(curr_state), .d(next_state));

// If next state will be wait then we will activate chunkff
dff chunky_counter[3:0](.clk(clk), .rst(rst | curr_chunk == 4'b1011), .wen(next_state), .q(curr_chunk), .d(next_chunk));


dff offset_counter[3:0](.clk(clk), .rst(rst | ~curr_state), .wen(memory_data_valid), .q(offset_cout), .d(sum_off));

carrylook_4bit chunkcount(.A(curr_chunk), .B(4'b1), .Cin(1'b0), .S(sum), .Cout());

carrylook_4bit offcount(.A(offset_cout), .B(4'b1), .Cin(1'b0), .S(sum_off), .Cout());

WordEnable_3_8 instr_off(.Wordline(word_select), .RegId(offset_address[3:1]));

assign next_state = (~curr_state) ? (miss_detected) : (chunks_left);
assign chunks_left = (curr_state & ~(curr_chunk == 4'b1011));
//assign next_state = curr_state ? curr_chunk == 4'b1011 : miss_detected;
//assign next_chunk = (memory_data_valid & curr_state) ? sum : curr_chunk;
assign next_chunk = (~curr_state) ?  1'b1 : miss_detected ? sum : curr_chunk;


assign memory_address = {miss_address[15:4], curr_chunk << 1};
assign offset_address = {miss_address[15:4], offset_cout << 1};

assign write_data_array = curr_state & memory_data_valid;
assign write_tag_array = curr_state & curr_chunk == 4'b1011;

assign busy_in = next_state;
assign fsm_busy = next_state | busy_out;

assign way_0 = (curr_chunk[0] == 0);
assign way_1 = (curr_chunk[1] == 1);





endmodule











/*
module cache_fill_FSM_test(clk, rst, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data, memory_data_valid, way_0, way_1, word_select);

input clk, rst;
input miss_detected; // active high when tag match logic detects a miss
input [15:0] miss_address; // address that missed the cache
output reg fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
output reg write_data_array; // write enable to cache data array to signal when filling with memory_data
output reg write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
output [15:0] memory_address; // address to read from memory
input [15:0] memory_data; // data returned by memory (after  delay)
input memory_data_valid; // active high indicates valid data returning on memory bus
output way_0, way_1;
output [7:0] word_select;
wire curr_state;
wire[3:0] curr_count;
reg next_state;
wire[3:0] next_count;

wire [15:0] fill_address;
wire[3:0] addr_out, addr_in, sum;

// Address to read more memory is the miss_address combined with offset
// that is determined by (chunk count * 2).
// Example: miss_address is 0x0312. Count is 0, so first address read is 0x0310,
// then 0x0312, etc. to 0x031e.
wire[3:0] offset;


assign offset = curr_count << 1;
assign memory_address = {miss_address[15:4], offset};
assign way_0 = curr_count[0] == 0;
assign way_1 = curr_count[1]== 1;

assign next_count = (~curr_state) ? 1'b1 : (miss_detected) ? sum : curr_count;
dff state(.q(curr_state), .d(next_state), .wen(1'b1), .clk(clk), .rst(rst));
dff ff1[3:0](.q(curr_count), .d(next_count), .wen(next_state), .clk(clk), .rst(rst | curr_count == 4'b1011));
dff ff2[3:0](.clk(clk), .rst(rst | ~curr_state), .q(addr_out), .d(addr_in), .wen(memory_data_valid));

carrylook_4bit kill_me(.A(addr_out), .B(4'b1), .Cin(1'b0), .S(addr_in), .Cout());
carrylook_4bit me(.A(curr_count), .B(4'b1), .Cin(1'b0), .S(sum), .Cout());

WordEnable_3_8 instr_off(.Wordline(word_select), .RegId(fill_address[3:1]));

assign fill_address = rst ? 16'b0 : {miss_address[15:4], addr_out << 1};

always @(clk)
casex({curr_state, miss_detected, memory_data_valid, curr_count})

	// Detect miss
	6'b0_1_x_xxxx: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = 3'b0001;
	end

	// First memory data chunk is not valid yet
	6'b1_x_0_0000: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0000: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b001;
	end

	// Second memory data chunk is not valid yet
	6'b1_x_0_0001: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0001: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b010;
	end

	// Third memory data chunk is not valid yet
	6'b1_x_0_0010: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0010: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b011;
	end

	// Fourth memory data chunk is not valid yet
	6'b1_x_0_0011: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0011: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b100;
	end

	// Fifth memory data chunk is not valid yet
	6'b1_x_0_0100: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0100: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b101;
	end

	// Sixth memory data chunk is not valid yet
	6'b1_x_0_0101: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0101: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b110;
	end

	// Seventh memory data chunk is not valid yet
	6'b1_x_0_0110: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - increase count
	6'b1_x_1_0110: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 1;
		write_tag_array = 0;
		//next_count = 3'b111;
	end

	// Eighth memory data chunk is not valid yet
	6'b1_x_0_0111: begin
		next_state = 1;
		fsm_busy = 1;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = curr_count;
	end
	// Chunk is valid - go back to IDLE
	6'b1_x_1_0111: begin
		next_state = 0;
		fsm_busy = 0;
		write_data_array = 1;
		write_tag_array = 1;
		//next_count = 3'b0;
	end

	default: begin
		next_state = 0;
		fsm_busy = 0;
		write_data_array = 0;
		write_tag_array = 0;
		//next_count = 3'b0;
	end
endcase

endmodule
*/