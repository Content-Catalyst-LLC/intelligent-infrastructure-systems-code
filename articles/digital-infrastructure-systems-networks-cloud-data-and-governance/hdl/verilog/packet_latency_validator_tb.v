`timescale 1ns / 1ps

module packet_latency_validator_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] latency_ms = 0;
reg [15:0] packet_loss_bps = 0;
reg [15:0] link_quality_bps = 0;
reg upstream_reachable = 0;
reg local_cache_available = 0;
reg fallback_route_available = 0;
reg identity_service_reachable = 0;
wire network_ok;
wire degraded_mode_required;
wire review_required;

packet_latency_validator dut (
    .clk(clk),
    .rst(rst),
    .latency_ms(latency_ms),
    .packet_loss_bps(packet_loss_bps),
    .link_quality_bps(link_quality_bps),
    .upstream_reachable(upstream_reachable),
    .local_cache_available(local_cache_available),
    .fallback_route_available(fallback_route_available),
    .identity_service_reachable(identity_service_reachable),
    .network_ok(network_ok),
    .degraded_mode_required(degraded_mode_required),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("packet_latency_validator_tb.vcd");
    $dumpvars(0, packet_latency_validator_tb);

    #10 rst = 0;

    latency_ms = 180;
    packet_loss_bps = 450;
    link_quality_bps = 6800;
    upstream_reachable = 1;
    local_cache_available = 1;
    fallback_route_available = 0;
    identity_service_reachable = 1;
    #20;

    if (network_ok !== 1'b0 || degraded_mode_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
