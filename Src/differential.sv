module differential(
    input logic clk,
    input logic rst,
    input logic channel,
    output logic channelp,
    output logic channeln
);

always_ff @(posedge clk) begin
    if(rst) begin
        channelp <= 0;
        channeln <= 0;
    end else begin
        channelp <= channel;
        channeln <= ~channel;
    end
end

endmodule
