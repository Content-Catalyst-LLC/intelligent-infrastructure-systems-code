`timescale 1ns / 1ps

module monitoring_stream_quality_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] metadata_count = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
reg schema_valid = 0;
reg unit_valid = 0;
reg sensor_health_ok = 0;
reg calibration_current = 0;
wire metadata_ok;
wire stream_ok;
wire calibration_ok;
wire review_required;

monitoring_stream_quality dut (
    .clk(clk),
    .rst(rst),
    .metadata_count(metadata_count),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .schema_valid(schema_valid),
    .unit_valid(unit_valid),
    .sensor_health_ok(sensor_health_ok),
    .calibration_current(calibration_current),
    .metadata_ok(metadata_ok),
    .stream_ok(stream_ok),
    .calibration_ok(calibration_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("monitoring_stream_quality_tb.vcd");
    $dumpvars(0, monitoring_stream_quality_tb);

    #10 rst = 0;

    metadata_count = 7;
    latency_seconds = 118;
    battery_mv = 3700;
    schema_valid = 1;
    unit_valid = 1;
    sensor_health_ok = 1;
    calibration_current = 0;
    #20;

    if (metadata_ok !== 1'b0 || stream_ok !== 1'b0 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
