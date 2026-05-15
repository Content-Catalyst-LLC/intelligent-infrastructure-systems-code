`timescale 1ns / 1ps

module transportation_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] speed_kph_x10 = 0;
reg [15:0] min_speed_kph_x10 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;
wire speed_ok;
wire review_required;

transportation_quality_check dut (
    .clk(clk),
    .rst(rst),
    .speed_kph_x10(speed_kph_x10),
    .min_speed_kph_x10(min_speed_kph_x10),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok),
    .speed_ok(speed_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("transportation_quality_check_tb.vcd");
    $dumpvars(0, transportation_quality_check_tb);

    #10 rst = 0;

    speed_kph_x10 = 240;
    min_speed_kph_x10 = 300;
    latency_seconds = 34;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b1 || speed_ok !== 1'b0 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
