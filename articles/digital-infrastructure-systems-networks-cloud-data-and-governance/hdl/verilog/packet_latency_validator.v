`timescale 1ns / 1ps

module packet_latency_validator #(
    parameter [15:0] MAX_LATENCY_MS = 250,
    parameter [15:0] MAX_PACKET_LOSS_BPS = 500,
    parameter [15:0] MIN_LINK_QUALITY_BPS = 7000
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] latency_ms,
    input  wire [15:0] packet_loss_bps,
    input  wire [15:0] link_quality_bps,
    input  wire        upstream_reachable,
    input  wire        local_cache_available,
    input  wire        fallback_route_available,
    input  wire        identity_service_reachable,
    output reg         network_ok,
    output reg         degraded_mode_required,
    output reg         review_required
);

always @(posedge clk) begin
    if (rst) begin
        network_ok <= 1'b0;
        degraded_mode_required <= 1'b0;
        review_required <= 1'b0;
    end else begin
        network_ok <= (latency_ms <= MAX_LATENCY_MS) &&
                      (packet_loss_bps <= MAX_PACKET_LOSS_BPS) &&
                      (link_quality_bps >= MIN_LINK_QUALITY_BPS) &&
                      upstream_reachable &&
                      local_cache_available &&
                      fallback_route_available &&
                      identity_service_reachable;

        degraded_mode_required <= (latency_ms > MAX_LATENCY_MS) ||
                                  (packet_loss_bps > MAX_PACKET_LOSS_BPS) ||
                                  (link_quality_bps < MIN_LINK_QUALITY_BPS) ||
                                  !upstream_reachable ||
                                  !fallback_route_available;

        review_required <= degraded_mode_required ||
                           !local_cache_available ||
                           !identity_service_reachable;
    end
end

endmodule
