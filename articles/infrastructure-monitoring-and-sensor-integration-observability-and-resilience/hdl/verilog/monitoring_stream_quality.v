`timescale 1ns / 1ps

module monitoring_stream_quality #(
    parameter [15:0] REQUIRED_METADATA_COUNT = 8,
    parameter [15:0] MAX_LATENCY_SECONDS = 120,
    parameter [15:0] MIN_BATTERY_MV = 3200
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] metadata_count,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    input  wire        schema_valid,
    input  wire        unit_valid,
    input  wire        sensor_health_ok,
    input  wire        calibration_current,
    output reg         metadata_ok,
    output reg         stream_ok,
    output reg         calibration_ok,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        metadata_ok <= 1'b0;
        stream_ok <= 1'b0;
        calibration_ok <= 1'b0;
        review_required <= 1'b0;
    end else begin
        metadata_ok <= metadata_count >= REQUIRED_METADATA_COUNT;
        calibration_ok <= calibration_current;

        stream_ok <= (metadata_count >= REQUIRED_METADATA_COUNT) &&
                     (latency_seconds <= MAX_LATENCY_SECONDS) &&
                     (battery_mv >= MIN_BATTERY_MV) &&
                     schema_valid &&
                     unit_valid &&
                     sensor_health_ok &&
                     calibration_current;

        review_required <= (metadata_count < REQUIRED_METADATA_COUNT) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           (battery_mv < MIN_BATTERY_MV) ||
                           !schema_valid ||
                           !unit_valid ||
                           !sensor_health_ok ||
                           !calibration_current;
    end
end

endmodule
