`timescale 1ns / 1ps

module water_quality_check #(
    parameter [15:0] BATTERY_MIN_MV = 3200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120,
    parameter [15:0] MIN_PRESSURE_PSI_X10 = 350,
    parameter [15:0] MAX_TURBIDITY_NTU_X100 = 100,
    parameter [15:0] MIN_CHLORINE_MG_L_X100 = 60,
    parameter [15:0] MAX_CHLORINE_MG_L_X100 = 400,
    parameter [15:0] MIN_PH_X100 = 650,
    parameter [15:0] MAX_PH_X100 = 850
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] pressure_psi_x10,
    input  wire [15:0] turbidity_ntu_x100,
    input  wire [15:0] chlorine_mg_l_x100,
    input  wire [15:0] ph_x100,
    input  wire [15:0] latency_seconds,
    input  wire [15:0] battery_mv,
    output reg         pressure_ok,
    output reg         quality_ok,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        pressure_ok <= 1'b0;
        quality_ok <= 1'b0;
        review_required <= 1'b0;
    end else begin
        pressure_ok <= pressure_psi_x10 >= MIN_PRESSURE_PSI_X10;

        quality_ok <= (pressure_psi_x10 >= MIN_PRESSURE_PSI_X10) &&
                      (turbidity_ntu_x100 <= MAX_TURBIDITY_NTU_X100) &&
                      (chlorine_mg_l_x100 >= MIN_CHLORINE_MG_L_X100) &&
                      (chlorine_mg_l_x100 <= MAX_CHLORINE_MG_L_X100) &&
                      (ph_x100 >= MIN_PH_X100) &&
                      (ph_x100 <= MAX_PH_X100) &&
                      (latency_seconds <= MAX_LATENCY_SECONDS) &&
                      (battery_mv >= BATTERY_MIN_MV);

        review_required <= (pressure_psi_x10 < MIN_PRESSURE_PSI_X10) ||
                           (turbidity_ntu_x100 > MAX_TURBIDITY_NTU_X100) ||
                           (chlorine_mg_l_x100 < MIN_CHLORINE_MG_L_X100) ||
                           (chlorine_mg_l_x100 > MAX_CHLORINE_MG_L_X100) ||
                           (ph_x100 < MIN_PH_X100) ||
                           (ph_x100 > MAX_PH_X100) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           (battery_mv < BATTERY_MIN_MV);
    end
end

endmodule
