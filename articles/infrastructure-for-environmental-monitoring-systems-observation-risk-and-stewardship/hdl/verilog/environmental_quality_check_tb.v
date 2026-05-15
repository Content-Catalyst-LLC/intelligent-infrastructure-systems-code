`timescale 1ns / 1ps

module environmental_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] value_x10 = 0;
reg [15:0] threshold_x10 = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire threshold_exceeded;

environmental_quality_check dut (
    .clk(clk),
    .rst(rst),
    .value_x10(value_x10),
    .threshold_x10(threshold_x10),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .threshold_exceeded(threshold_exceeded)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("environmental_quality_check_tb.vcd");
    $dumpvars(0, environmental_quality_check_tb);

    #10 rst = 0;

    value_x10 = 362;
    threshold_x10 = 350;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b1 || threshold_exceeded !== 1'b1) begin
        $display("FAIL: expected quality_ok=1 and threshold_exceeded=1");
        $finish;
    end

    value_x10 = 100;
    threshold_x10 = 350;
    battery_mv = 3000;
    #10;

    if (quality_ok !== 1'b0 || threshold_exceeded !== 1'b0) begin
        $display("FAIL: expected quality_ok=0 and threshold_exceeded=0");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
