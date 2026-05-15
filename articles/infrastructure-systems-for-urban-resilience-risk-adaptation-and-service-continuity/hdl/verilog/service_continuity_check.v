`timescale 1ns / 1ps

// Simple fixed-point service-continuity checker for urban infrastructure telemetry.
// Example scale:
//   service_capacity_x10 = service capacity percent * 10
//   threshold_x10 = threshold percent * 10
//   battery_mv = battery voltage in millivolts

module service_continuity_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] service_capacity_x10,
    input  wire [15:0] threshold_x10,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         continuity_ok,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        continuity_ok <= 1'b0;
        review_required <= 1'b0;
    end else begin
        quality_ok <= (battery_mv >= BATTERY_MIN_MV) && (service_capacity_x10 <= 1000);
        continuity_ok <= (service_capacity_x10 >= threshold_x10);
        review_required <= (service_capacity_x10 < threshold_x10) || (battery_mv < BATTERY_MIN_MV);
    end
end

endmodule
