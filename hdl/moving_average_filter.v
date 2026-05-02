module moving_average_filter #(
    parameter DATA_WIDTH = 16
)(
    input wire clk,
    input wire reset_n,
    input wire valid_in,
    input wire [DATA_WIDTH-1:0] sample_in,
    output reg [DATA_WIDTH-1:0] average_out
);

reg [DATA_WIDTH-1:0] previous_sample;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        previous_sample <= 0;
        average_out <= 0;
    end else if (valid_in) begin
        average_out <= (sample_in + previous_sample) >> 1;
        previous_sample <= sample_in;
    end
end

endmodule
