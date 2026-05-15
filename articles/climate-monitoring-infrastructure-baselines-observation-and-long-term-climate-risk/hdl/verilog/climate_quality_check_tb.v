`timescale 1ns / 1ps

module climate_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg signed [15:0] temp_c_x10 = 0;
reg [15:0] humidity_x10 = 0;
reg [15:0] battery_mv = 0;
wire quality_ok;

climate_quality_check dut (
    .clk(clk),
    .rst(rst),
    .temp_c_x10(temp_c_x10),
    .humidity_x10(humidity_x10),
    .battery_mv(battery_mv),
    .quality_ok(quality_ok)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("climate_quality_check_tb.vcd");
    $dumpvars(0, climate_quality_check_tb);

    #10 rst = 0;

    temp_c_x10 = 248;
    humidity_x10 = 515;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b1) begin
        $display("FAIL: expected quality_ok=1");
        $finish;
    end

    temp_c_x10 = 900;
    humidity_x10 = 515;
    battery_mv = 3800;
    #10;

    if (quality_ok !== 1'b0) begin
        $display("FAIL: expected quality_ok=0");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
