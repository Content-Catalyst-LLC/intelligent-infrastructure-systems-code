`timescale 1ns / 1ps

module smart_city_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] observed_capacity_x1000 = 0;
reg [15:0] normal_capacity_x1000 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire service_ok;
wire review_required;

smart_city_quality_check dut (
    .clk(clk),
    .rst(rst),
    .observed_capacity_x1000(observed_capacity_x1000),
    .normal_capacity_x1000(normal_capacity_x1000),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .service_ok(service_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("smart_city_quality_check_tb.vcd");
    $dumpvars(0, smart_city_quality_check_tb);

    #10 rst = 0;

    observed_capacity_x1000 = 580;
    normal_capacity_x1000 = 1000;
    latency_seconds = 55;
    battery_mv = 3800;
    #20;

    if (quality_ok !== 1'b1 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
