`timescale 1ns / 1ps

module energy_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] voltage_pu_x1000 = 0;
reg [15:0] temperature_c_x10 = 0;
reg [15:0] loading_x1000 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire voltage_ok;
wire review_required;

energy_quality_check dut (
    .clk(clk),
    .rst(rst),
    .voltage_pu_x1000(voltage_pu_x1000),
    .temperature_c_x10(temperature_c_x10),
    .loading_x1000(loading_x1000),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .voltage_ok(voltage_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("energy_quality_check_tb.vcd");
    $dumpvars(0, energy_quality_check_tb);

    #10 rst = 0;

    voltage_pu_x1000 = 950;
    temperature_c_x10 = 710;
    loading_x1000 = 960;
    latency_seconds = 63;
    battery_mv = 3800;
    #20;

    if (voltage_ok !== 1'b1 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
