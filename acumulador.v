`timescale 1ns / 1ps

module acumulador (
    input  wire        clk, rst, start, cancel,
    input  wire [3:0]  x,
    output reg  [5:0]  acc,
    output wire        done
);

    localparam S_IDLE  = 2'b00;
    localparam S_LOAD  = 2'b01;
    localparam S_ADD   = 2'b10;
    localparam S_DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] count;

    always @(*) begin
        next_state = state;

        case (state)
            S_IDLE: begin
                if (start)
                    next_state = S_LOAD;
                end

            S_LOAD: begin
                if (cancel)
                    next_state = S_IDLE;
                else
                    next_state = S_ADD;
                end

            S_ADD: begin
                if (cancel)
                    next_state = S_IDLE;
                else if (count == 2'd3)     // después de la 3ra suma → DONE
                    next_state = S_DONE;
                end

            S_DONE: begin
                next_state = S_IDLE;
                end

            default: begin
                next_state = S_IDLE;
                end
        endcase
    end

    assign done = (state == S_DONE);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc   <= 6'd0;
            count <= 2'd0;
            state <= S_IDLE;
        end
        else begin
            state <= next_state;
            case (state)
                S_LOAD: begin
                    acc   <= 6'd0;
                    count <= 2'd0;
                    end

                S_ADD: begin
                    acc   <= acc + {2'b00, x};
                    count <= count + 2'd1;
                    end

                default: begin
                    end
            endcase
        end
    end

endmodule