`timescale 1ns / 1ps

module grid_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120,
    parameter [15:0] MIN_VOLTAGE_PU_X1000 = 950,
    parameter [15:0] MAX_VOLTAGE_PU_X1000 = 1050,
    parameter [15:0] MIN_FREQUENCY_HZ_X100 = 5995,
    parameter [15:0] MAX_FREQUENCY_HZ_X100 = 6005,
    parameter [15:0] MAX_LOADING_X1000 = 950
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] voltage_pu_x1000,
    input  wire [15:0] frequency_hz_x100,
    input  wire [15:0] loading_x1000,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         voltage_ok,
    output reg         frequency_ok,
    output reg         quality_ok,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        voltage_ok <= 1'b0;
        frequency_ok <= 1'b0;
        quality_ok <= 1'b0;
        review_required <= 1'b0;
    end else begin
        voltage_ok <= (voltage_pu_x1000 >= MIN_VOLTAGE_PU_X1000) &&
                      (voltage_pu_x1000 <= MAX_VOLTAGE_PU_X1000);

        frequency_ok <= (frequency_hz_x100 >= MIN_FREQUENCY_HZ_X100) &&
                        (frequency_hz_x100 <= MAX_FREQUENCY_HZ_X100);

        quality_ok <= voltage_ok &&
                      frequency_ok &&
                      (loading_x1000 <= MAX_LOADING_X1000) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS) &&
                      (battery_mv >= BATTERY_MIN_MV);

        review_required <= !voltage_ok ||
                           !frequency_ok ||
                           (loading_x1000 > MAX_LOADING_X1000) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           (battery_mv < BATTERY_MIN_MV);
    end
end

endmodule
