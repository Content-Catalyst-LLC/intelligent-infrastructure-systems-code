`timescale 1ns / 1ps

module urban_sensor_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 300
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] value_x10,
    input  wire [15:0] threshold_x10,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         threshold_exceeded,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        threshold_exceeded <= 1'b0;
        review_required <= 1'b0;
    end else begin
        quality_ok <= (battery_mv >= BATTERY_MIN_MV) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS);
        threshold_exceeded <= (value_x10 >= threshold_x10);
        review_required <= (value_x10 >= threshold_x10) ||
                           (battery_mv < BATTERY_MIN_MV) ||
                           (latency_seconds > MAX_LATENCY_SECONDS);
    end
end

endmodule
