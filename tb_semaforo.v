`timescale 1ns/1ns
`include "semaforo.v"

module tb_semaforo;
    reg clk;
    reg rst;
    wire green;
    wire yellow;
    wire red;

    semaforo dut(
        .clk(clk),
        .rst(rst),
        .green(green),
        .yellow(yellow),
        .red(red)
    );

    initial begin
        $dumpfile("semaforo.vcd");
        $dumpvars(0, tb_semaforo);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #1;
        rst = 0;

        #135;
        rst =1;
        #1;
        rst = 0;


        #200;
        $finish;
    end


endmodule