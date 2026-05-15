`timescale 1ns / 1ps

// Simple fixed-point threshold detector for edge early-warning pipelines.
// Inputs are unsigned fixed-point scaled integers.
// Example scale: rainfall_x10 = rainfall_mm_hr * 10.

module early_warning_threshold #(
    parameter integer RAINFALL_THRESHOLD_X10 = 350,
    parameter integer RIVER_STAGE_THRESHOLD_X100 = 350,
    parameter integer SOIL_SAT_THRESHOLD_X100 = 75
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] rainfall_x10,
    input  wire [15:0] river_stage_x100,
    input  wire [15:0] soil_sat_x100,
    output reg         local_watch
);

always @(posedge clk) begin
    if (rst) begin
        local_watch <= 1'b0;
    end else begin
        local_watch <= ((rainfall_x10 >= RAINFALL_THRESHOLD_X10) &&
                        (soil_sat_x100 >= SOIL_SAT_THRESHOLD_X100)) ||
                       (river_stage_x100 >= RIVER_STAGE_THRESHOLD_X100);
    end
end

endmodule
