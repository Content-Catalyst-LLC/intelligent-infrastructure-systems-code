`timescale 1ns / 1ps

module water_quality_check_tb;

reg clk = 0;
reg rst = 1;
reg [15:0] pressure_psi_x10 = 0;
reg [15:0] turbidity_ntu_x100 = 0;
reg [15:0] chlorine_mg_l_x100 = 0;
reg [15:0] ph_x100 = 0;
reg [15:0] latency_seconds = 0;
reg [15:0] battery_mv = 0;
wire pressure_ok;
wire quality_ok;
wire review_required;

water_quality_check dut (
    .clk(clk),
    .rst(rst),
    .pressure_psi_x10(pressure_psi_x10),
    .turbidity_ntu_x100(turbidity_ntu_x100),
    .chlorine_mg_l_x100(chlorine_mg_l_x100),
    .ph_x100(ph_x100),
    .latency_seconds(latency_seconds),
    .battery_mv(battery_mv),
    .pressure_ok(pressure_ok),
    .quality_ok(quality_ok),
    .review_required(review_required)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("water_quality_check_tb.vcd");
    $dumpvars(0, water_quality_check_tb);

    #10 rst = 0;

    pressure_psi_x10 = 340;
    turbidity_ntu_x100 = 90;
    chlorine_mg_l_x100 = 50;
    ph_x100 = 710;
    latency_seconds = 88;
    battery_mv = 3800;
    #20;

    if (pressure_ok !== 1'b0 || quality_ok !== 1'b0 || review_required !== 1'b1) begin
        $display("FAIL");
        $finish;
    end

    $display("PASS");
    $finish;
end

endmodule
