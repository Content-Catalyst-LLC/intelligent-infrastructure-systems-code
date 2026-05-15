`timescale 1ns / 1ps

module urban_sensor_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] value_x10 = 0;
reg [15:0] threshold_x10 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire threshold_exceeded;
wire review_required;

urban_sensor_quality_check dut (
    .clk(clk),
    .rst(rst),
    .value_x10(value_x10),
    .threshold_x10(threshold_x10),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .threshold_exceeded(threshold_exceeded),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("urban_sensor_quality_check_tb.vcd");
    $dumpvars(0, urban_sensor_quality_check_tb);

    #10 rst = 0;

    value_x10 = 368;
    threshold_x10 = 350;
    latency_seconds = 44;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b1 || threshold_exceeded !== 1'b1 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
