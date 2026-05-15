`timescale 1ns / 1ps

module transportation_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] speed_kph_x10,
    input  wire [15:0] min_speed_kph_x10,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         speed_ok,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        speed_ok <= 1'b0;
        review_required <= 1'b0;
    end else begin
        quality_ok <= (battery_mv >= BATTERY_MIN_MV) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS);
        speed_ok <= (speed_kph_x10 >= min_speed_kph_x10);
        review_required <= (speed_kph_x10 < min_speed_kph_x10) ||
                           (battery_mv < BATTERY_MIN_MV) ||
                           (latency_seconds > MAX_LATENCY_SECONDS);
    end
end

endmodule
