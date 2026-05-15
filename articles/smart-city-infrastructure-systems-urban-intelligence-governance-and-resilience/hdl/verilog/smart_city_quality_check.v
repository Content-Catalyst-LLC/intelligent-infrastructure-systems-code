`timescale 1ns / 1ps

module smart_city_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120,
    parameter [15:0] MIN_CONTINUITY_X1000 = 750
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] observed_capacity_x1000,
    input  wire [15:0] normal_capacity_x1000,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         service_ok,
    output reg         review_required
);

reg [31:0] continuity_x1000;

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        service_ok <= 1'b0;
        review_required <= 1'b0;
        continuity_x1000 <= 32'd0;
    end else begin
        if (normal_capacity_x1000 > 0) begin
            continuity_x1000 <= (observed_capacity_x1000 * 1000) / normal_capacity_x1000;
        end else begin
            continuity_x1000 <= 32'd0;
        end

        quality_ok <= (battery_mv >= BATTERY_MIN_MV) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS) &&
                      (normal_capacity_x1000 > 0);

        service_ok <= (continuity_x1000 >= MIN_CONTINUITY_X1000);

        review_required <= (continuity_x1000 < MIN_CONTINUITY_X1000) ||
                           (battery_mv < BATTERY_MIN_MV) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           (normal_capacity_x1000 == 0);
    end
end

endmodule
