`timescale 1ns / 1ps

// Simple fixed-point quality and threshold checker for environmental telemetry.
// Example scale:
//   value_x10 = sensor value * 10
//   threshold_x10 = threshold value * 10
//   battery_mv = battery voltage in millivolts

module environmental_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] value_x10,
    input  wire [15:0] threshold_x10,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         threshold_exceeded
);

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        threshold_exceeded <= 1'b0;
    end else begin
        quality_ok <= (battery_mv >= BATTERY_MIN_MV);
        threshold_exceeded <= (value_x10 >= threshold_x10);
    end
end

endmodule
