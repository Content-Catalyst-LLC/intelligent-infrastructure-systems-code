`timescale 1ns / 1ps

module grid_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] voltage_pu_x1000 = 0;
reg [15:0] frequency_hz_x100 = 0;
reg [15:0] loading_x1000 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire voltage_ok;
wire frequency_ok;
wire quality_ok;
wire review_required;

grid_quality_check dut (
    .clk(clk),
    .rst(rst),
    .voltage_pu_x1000(voltage_pu_x1000),
    .frequency_hz_x100(frequency_hz_x100),
    .loading_x1000(loading_x1000),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .voltage_ok(voltage_ok),
    .frequency_ok(frequency_ok),
    .quality_ok(quality_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("grid_quality_check_tb.vcd");
    $dumpvars(0, grid_quality_check_tb);

    #10 rst = 0;

    voltage_pu_x1000 = 940;
    frequency_hz_x100 = 5997;
    loading_x1000 = 960;
    latency_seconds = 88;
    battery_mv = 3800;
    #20;

    if (voltage_ok !== 1'b0 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
