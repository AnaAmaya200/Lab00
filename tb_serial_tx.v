`timescale 1ns / 1ps
`include "serial_tx.v" 

module tb_serial_tx();

    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    
    wire tx;
    wire busy;
    wire done;

    parameter CLKS_PER_BIT = 8;

    serial_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("serial.vcd");
        $dumpvars(0, tb_serial_tx); 

        clk = 0;
        rst = 0;
        start = 0;
        data_in = 8'd0;

        @(negedge clk);
        rst = 1;
        #20; 
        rst = 0;
        #20;

        @(negedge clk);
        data_in = 8'hA5;
        start = 1;
        
        @(negedge clk); 
        start = 0;

        @(posedge done); 
        #40;

        @(negedge clk);
        rst = 1;
        #20;
        rst = 0;
        #20;

        @(negedge clk);
        data_in = 8'h3C;
        start = 1;
        
        @(negedge clk); 
        start = 0;

        @(posedge done);
        #40;
        $finish;
    end

endmodule