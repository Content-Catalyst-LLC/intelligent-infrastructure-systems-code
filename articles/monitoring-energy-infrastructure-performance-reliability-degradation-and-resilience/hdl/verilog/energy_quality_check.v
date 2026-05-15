`timescale 1ns / 1ps

module energy_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120,
    parameter [15:0] MIN_VOLTAGE_PU_X1000 = 950,
    parameter [15:0] MAX_VOLTAGE_PU_X1000 = 1050,
    parameter [15:0] MAX_TEMPERATURE_C_X10 = 700,
    parameter [15:0] MAX_LOADING_X1000 = 950
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] voltage_pu_x1000,
    input  wire [15:0] temperature_c_x10,
    input  wire [15:0] loading_x1000,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         quality_ok,
    output reg         voltage_ok,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        quality_ok <= 1'b0;
        voltage_ok <= 1'b0;
        review_required <= 1'b0;
    end else begin
        voltage_ok <= (voltage_pu_x1000 >= MIN_VOLTAGE_PU_X1000) &&
                      (voltage_pu_x1000 <= MAX_VOLTAGE_PU_X1000);

        quality_ok <= voltage_ok &&
                      (temperature_c_x10 <= MAX_TEMPERATURE_C_X10) &&
                      (loading_x1000 <= MAX_LOADING_X1000) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS) &&
                      (battery_mv >= BATTERY_MIN_MV);

        review_required <= !voltage_ok ||
                           (temperature_c_x10 > MAX_TEMPERATURE_C_X10) ||
                           (loading_x1000 > MAX_LOADING_X1000) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           (battery_mv < BATTERY_MIN_MV);
    end
end

endmodule
