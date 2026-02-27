module serial_tx #(
    parameter CLKS_PER_BIT = 8 
)(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg tx,
    output reg busy,
    output reg done
);

 
    localparam IDLE = 3'd0;
    localparam LOAD = 3'd1;
    localparam BIT_HOLD = 3'd2;
    localparam SHIFT_NEXT = 3'd3;
    localparam DONE = 3'd4;


    reg [2:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    
    reg [$clog2(CLKS_PER_BIT)-1:0] tick_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            tick_cnt <= 0;
            tx <= 1'b1;
            busy <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; 
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                    end
                end

                LOAD: begin
                    shift_reg <= data_in;
                    bit_count <= 3'd0;
                    tick_cnt  <= 0;
                    busy <= 1'b1;
                    state <= BIT_HOLD;
                end

                BIT_HOLD: begin
                    tx <= shift_reg[0];
                    if (tick_cnt == (CLKS_PER_BIT - 2)) begin
                        state <= SHIFT_NEXT;
                    end else begin
                        tick_cnt <= tick_cnt + 1;
                    end
                end

                SHIFT_NEXT: begin
                    tick_cnt <= 0;
                    shift_reg <= shift_reg >> 1;
                    if (bit_count == 3'd7) begin
                        state <= DONE;
                    end else begin
                        bit_count <= bit_count + 1;
                        state <= BIT_HOLD;
                    end
                end

                DONE: begin
                    done  <= 1'b1;
                    busy  <= 1'b0;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule