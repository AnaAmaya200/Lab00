`timescale 1ns / 1ps
`include "acumulador.v"

module acumulador_tb;

    reg clk;
    reg rst;
    reg start;
    reg cancel;
    reg [3:0] x;
    
    wire [5:0] acc;
    wire done;

    acumulador dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .cancel(cancel),
        .x(x),
        .acc(acc),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("prueba.vcd");
        $dumpvars(0, acumulador_tb);
    end

    initial begin
        
        rst = 1;
        start = 0;
        cancel = 0;
        x = 4'd0;

        #10;
        rst = 0;

        #20;
        x = 4'd5;
        start = 1;
        #10;
        start = 0;

        #80;
        x = 4'd3;
        start = 1;
        #10;
        start = 0;
        #10;
        cancel = 1;
        #10;
        cancel = 0;

        #80;
        x = 4'd1;
        start = 1;
        #10;
        start = 0;
        #20;
        cancel = 1;
        #10;
        cancel = 0;

        #40;
        x = 4'd1;
        start = 1;
        #10;
        start = 0;

        #100;

        $finish;
    end

endmodule