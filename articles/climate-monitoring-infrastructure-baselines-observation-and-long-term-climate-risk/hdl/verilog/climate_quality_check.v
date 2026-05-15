`timescale 1ns / 1ps

// Simple fixed-point quality checker for climate station telemetry.
// Example scale:
//   temp_c_x10 = temperature_C * 10, signed
//   humidity_x10 = relative_humidity_percent * 10
//   battery_mv = battery voltage in millivolts

module climate_quality_check #(
    parameter signed [15:0] TEMP_MIN_X10 = -800,
    parameter signed [15:0] TEMP_MAX_X10 = 600,
    parameter [15:0] HUMIDITY_MIN_X10 = 0,
    parameter [15:0] HUMIDITY_MAX_X10 = 1000,
    parameter [15:0] BATTERY_MIN_MV = 3200
)(
    input  wire              clk,
    input  wire              rst,
    input  wire signed [15:0] temp_c_x10,
    input  wire [15:0]       humidity_x10,
    input  wire [15:0]       battery_mv,
    output reg               quality_ok
);

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
    end else begin
        quality_ok <= (temp_c_x10 >= TEMP_MIN_X10) &&
                      (temp_c_x10 <= TEMP_MAX_X10) &&
                      (humidity_x10 >= HUMIDITY_MIN_X10) &&
                      (humidity_x10 <= HUMIDITY_MAX_X10) &&
                      (battery_mv >= BATTERY_MIN_MV);
    end
end

endmodule
