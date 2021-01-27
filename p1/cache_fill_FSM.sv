module cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data, memory_data_valid);
input wire clk, rst_n;
input wire miss_detected; // active high when tag match logic detects a miss
input wire[15:0] miss_address; // address that missed the cache
output reg fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
output reg write_data_array; // write enable to cache data array to signal when filling with memory_data
output reg write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
output wire[15:0] memory_address; // address to read from memory
input wire[15:0] memory_data; // data returned by memory (after  delay)
input wire memory_data_valid; // active high indicates valid data returning on memory bus

wire currentState;
wire[1:0] count;

reg nextState;
reg[1:0] nextCount;

// 
dff flipflop(.q(currentState), .d(nextState), .wen(1'b1), .clk(clk), .rst(~rst_n));

dff flipflop2[1:0](.q(count), .d(nextCount), .wen(1'b1), .clk(clk), .rst(~rst_n));

assign memory_address = miss_address;

always @(clk)

casex({currentState, count, memory_data_valid, miss_detected})

5'b0_XX_X_0: begin
fsm_busy = 0;
write_tag_array = 0;
write_data_array = 0;
nextCount = 0;
nextState = 0;
end

5'b0_XX_X_1: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 0;
nextState = 1;
end

5'b1_00_0_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 0;
nextState = 1;
end

5'b1_00_1_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 1;
nextState = 1;
end

5'b1_01_0_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 1;
nextState = 1;
end

5'b1_01_1_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 2;
nextState = 1;
end

5'b1_10_0_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 2;
nextState = 1;
end

5'b1_10_1_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 3;
nextState = 1;
end

5'b1_11_0_X: begin
fsm_busy = 1;
write_tag_array = 0;
write_data_array = 1;
nextCount = 3;
nextState = 1;
end

5'b1_11_1_X: begin
fsm_busy = 0;
write_tag_array = 1;
write_data_array = 0;
nextCount = 0;
nextState = 0;
end

default : begin
fsm_busy = 0;
write_tag_array = 0;
write_data_array = 0;
nextCount = 0;
nextState = 0;
end 

endcase

endmodule