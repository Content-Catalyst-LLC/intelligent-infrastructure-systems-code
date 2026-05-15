`timescale 1ns / 1ps

module control_stream_integrity #(
    parameter [15:0] MIN_COMMAND = 0,
    parameter [15:0] MAX_COMMAND = 200,
    parameter [15:0] MAX_LATENCY_SECONDS = 120
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] command_value,
    input  wire [15:0] latency_seconds,
    input  wire        telemetry_valid,
    input  wire        operator_ack,
    input  wire        fallback_available,
    input  wire        manual_override_available,
    input  wire        safe_state_available,
    output reg         command_valid,
    output reg         control_permitted,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        command_valid <= 1'b0;
        control_permitted <= 1'b0;
        review_required <= 1'b0;
    end else begin
        command_valid <= (command_value >= MIN_COMMAND) && (command_value <= MAX_COMMAND);

        control_permitted <= (command_value >= MIN_COMMAND) &&
                             (command_value <= MAX_COMMAND) &&
                             (latency_seconds <= MAX_LATENCY_SECONDS) &&
                             telemetry_valid &&
                             operator_ack &&
                             fallback_available &&
                             manual_override_available &&
                             safe_state_available;

        review_required <= (command_value < MIN_COMMAND) ||
                           (command_value > MAX_COMMAND) ||
                           (latency_seconds > MAX_LATENCY_SECONDS) ||
                           !telemetry_valid ||
                           !operator_ack ||
                           !fallback_available ||
                           !manual_override_available ||
                           !safe_state_available;
    end
end

endmodule
