`timescale 1ns / 1ps

module renewable_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] voltage_pu_x1000 = 0;
reg [15:0] actual_generation_mw_x10 = 0;
reg [15:0] forecast_generation_mw_x10 = 0;
reg [15:0] inverter_temp_c_x10 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire voltage_ok;
wire forecast_review;
wire review_required;

renewable_quality_check dut (
    .clk(clk),
    .rst(rst),
    .voltage_pu_x1000(voltage_pu_x1000),
    .actual_generation_mw_x10(actual_generation_mw_x10),
    .forecast_generation_mw_x10(forecast_generation_mw_x10),
    .inverter_temp_c_x10(inverter_temp_c_x10),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .voltage_ok(voltage_ok),
    .forecast_review(forecast_review),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("renewable_quality_check_tb.vcd");
    $dumpvars(0, renewable_quality_check_tb);

    #10 rst = 0;

    voltage_pu_x1000 = 960;
    actual_generation_mw_x10 = 1180;
    forecast_generation_mw_x10 = 1350;
    inverter_temp_c_x10 = 580;
    latency_seconds = 65;
    battery_mv = 3800;
    #30;

    if (voltage_ok !== 1'b1 || quality_ok !== 1'b1 || review_required !== 1'b0) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
