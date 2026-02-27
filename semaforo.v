module semaforo(
    input wire clk,
    input wire rst,
    output reg green,
    output reg yellow,
    output reg red
);

reg [1:0] state, nextstate;
reg [2:0] counter;

localparam s0 = 2'b00;
localparam s1 = 2'b01;
localparam s2 = 2'b10;



always@(posedge clk or posedge rst) begin
    if (rst) begin
        state <= s0;
        counter <= 3'b000;
    end
    else begin 
        case (state)
            s0: begin
                if (counter == 3'b011) begin
                    state <= s1;
                    counter <= 3'b000;
                end
                else begin
                    counter <= counter +1;
                end
            end
            s1: begin
                if (counter == 3'b000) begin
                    state <= s2;
                    counter <= 3'b000;
                end
                else begin
                    counter <= counter +1;
                end
            end
            s2: begin 
                if (counter == 3'b010) begin
                    state <= s0;
                    counter <= 3'b000;
                end
                else begin
                    counter <= counter +1;
                end
            end
            default: begin 
                nextstate <= s0;
            end
        endcase
    end
end
always@(state)begin
    green = 2'b00;
    yellow = 2'b00;
    red = 2'b00;       
    
    case (state)
        s0: green = 2'b01;
        s1: yellow = 2'b01;
        s2: red = 2'b01;

        endcase
    end
    
endmodule
