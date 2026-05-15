`timescale 1ns / 1ps

module renewable_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120,
    parameter [15:0] MIN_VOLTAGE_PU_X1000 = 950,
    parameter [15:0] MAX_VOLTAGE_PU_X1000 = 1050,
    parameter [15:0] MAX_INVERTER_TEMP_C_X10 = 700
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] voltage_pu_x1000,
    input  wire [15:0] actual_generation_mw_x10,
    input  wire [15:0] forecast_generation_mw_x10,
    input  wire [15:0] inverter_temp_c_x10,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         voltage_ok,
    output reg         forecast_review,
    output reg         review_required
);

reg [15:0] forecast_error_x10;

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        voltage_ok <= 1'b0;
        forecast_review <= 1'b0;
        review_required <= 1'b0;
        forecast_error_x10 <= 16'd0;
    end else begin
        voltage_ok <= (voltage_pu_x1000 >= MIN_VOLTAGE_PU_X1000) &&
                      (voltage_pu_x1000 <= MAX_VOLTAGE_PU_X1000);

        if (forecast_generation_mw_x10 >= actual_generation_mw_x10) begin
            forecast_error_x10 <= forecast_generation_mw_x10 - actual_generation_mw_x10;
        end else begin
            forecast_error_x10 <= actual_generation_mw_x10 - forecast_generation_mw_x10;
        end

        forecast_review <= (forecast_generation_mw_x10 > 0) &&
                           ((forecast_error_x10 * 100) > (forecast_generation_mw_x10 * 25));

        quality_ok <= voltage_ok &&
                      (inverter_temp_c_x10 <= MAX_INVERTER_TEMP_C_X10) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS) &&
                      (battery_mv >= BATTERY_MIN_MV);

        review_required <= !voltage_ok ||
                           forecast_review ||
                           (inverter_temp_c_x10 > MAX_INVERTER_TEMP_C_X10) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           (battery_mv < BATTERY_MIN_MV);
    end
end

endmodule
