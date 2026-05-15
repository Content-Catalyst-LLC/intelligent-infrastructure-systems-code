`timescale 1ns / 1ps

module service_continuity_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] service_capacity_x10 = 0;
reg [15:0] threshold_x10 = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire continuity_ok;
wire review_required;

service_continuity_check dut (
    .clk(clk),
    .rst(rst),
    .service_capacity_x10(service_capacity_x10),
    .threshold_x10(threshold_x10),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .continuity_ok(continuity_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("service_continuity_check_tb.vcd");
    $dumpvars(0, service_continuity_check_tb);

    #10 rst = 0;

    service_capacity_x10 = 580;
    threshold_x10 = 750;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b1 || continuity_ok !== 1'b0 || review_required !== 1'b1) begin
        $display("FAIL: expected quality_ok=1, continuity_ok=0, review_required=1");
        $finish;
    end

    service_capacity_x10 = 820;
    threshold_x10 = 750;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b1 || continuity_ok !== 1'b1 || review_required !== 1'b0) begin
        $display("FAIL: expected quality_ok=1, continuity_ok=1, review_required=0");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
