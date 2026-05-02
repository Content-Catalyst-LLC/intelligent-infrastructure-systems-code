module finite_state_alert_controller (
    input wire clk,
    input wire reset_n,
    input wire anomaly_in,
    input wire ack_in,
    output reg alert_active
);

localparam NORMAL = 1'b0;
localparam ALERT  = 1'b1;

reg state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= NORMAL;
        alert_active <= 1'b0;
    end else begin
        case (state)
            NORMAL: begin
                if (anomaly_in) begin
                    state <= ALERT;
                    alert_active <= 1'b1;
                end
            end
            ALERT: begin
                if (ack_in) begin
                    state <= NORMAL;
                    alert_active <= 1'b0;
                end
            end
        endcase
    end
end

endmodule
