`timescale 1ns / 1ps

module control_stream_integrity_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] command_value = 0;
reg [15:0] latency_seconds = 0;
reg telemetry_valid = 0;
reg operator_ack = 0;
reg fallback_available = 0;
reg manual_override_available = 0;
reg safe_state_available = 0;
wire command_valid;
wire control_permitted;
wire review_required;

control_stream_integrity dut (
    .clk(clk),
    .rst(rst),
    .command_value(command_value),
    .latency_seconds(latency_seconds),
    .telemetry_valid(telemetry_valid),
    .operator_ack(operator_ack),
    .fallback_available(fallback_available),
    .manual_override_available(manual_override_available),
    .safe_state_available(safe_state_available),
    .command_valid(command_valid),
    .control_permitted(control_permitted),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("control_stream_integrity_tb.vcd");
    $dumpvars(0, control_stream_integrity_tb);

    #10 rst = 0;

    command_value = 100;
    latency_seconds = 25;
    telemetry_valid = 1;
    operator_ack = 1;
    fallback_available = 0;
    manual_override_available = 1;
    safe_state_available = 1;
    #20;

    if (command_valid !== 1'b1 || control_permitted !== 1'b0 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
