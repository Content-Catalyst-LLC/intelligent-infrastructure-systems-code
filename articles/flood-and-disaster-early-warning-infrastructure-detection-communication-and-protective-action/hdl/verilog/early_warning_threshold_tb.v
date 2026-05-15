`timescale 1ns / 1ps

module early_warning_threshold_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] rainfall_x10 = 0;
reg [15:0] river_stage_x100 = 0;
reg [15:0] soil_sat_x100 = 0;
wire local_watch;

early_warning_threshold dut (
    .clk(clk),
    .rst(rst),
    .rainfall_x10(rainfall_x10),
    .river_stage_x100(river_stage_x100),
    .soil_sat_x100(soil_sat_x100),
    .local_watch(local_watch)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("early_warning_threshold_tb.vcd");
    $dumpvars(0, early_warning_threshold_tb);

    #10 rst = 0;

    rainfall_x10 = 420;
    river_stage_x100 = 310;
    soil_sat_x100 = 82;
    #10;

    if (local_watch !== 1'b1) begin
        $display("FAIL: expected local_watch=1");
        $finish;
    end

    rainfall_x10 = 100;
    river_stage_x100 = 200;
    soil_sat_x100 = 30;
    #10;

    if (local_watch !== 1'b0) begin
        $display("FAIL: expected local_watch=0");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
