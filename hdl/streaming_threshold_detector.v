module streaming_threshold_detector #(
    parameter DATA_WIDTH = 16
)(
    input wire clk,
    input wire reset_n,
    input wire valid_in,
    input wire [DATA_WIDTH-1:0] sensor_value,
    input wire [DATA_WIDTH-1:0] threshold_value,
    output reg alert_out
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        alert_out <= 1'b0;
    end else begin
        if (valid_in && sensor_value > threshold_value) begin
            alert_out <= 1'b1;
        end else begin
            alert_out <= 1'b0;
        end
    end
end

endmodule
