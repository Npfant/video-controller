module stimulus();

logic clk;
logic x_clk;
logic rst;
logic [9:0] data;
logic [10:0] cycle;
logic serialized;

initial begin
    clk = 1;
    x_clk = 1;
    rst = 1;
    #2 rst = 0;
end

serializer test(
    clk, x_clk, rst, data, serialized
);

always @ (posedge clk) begin
    if (rst) begin
        cycle <= 0;
        data <= 0;
    end
    else begin
        cycle <= cycle + 1;
        data <= cycle[9:0];
    end
end

always begin
    #1 x_clk = ~x_clk;
end
always begin
    #10 clk = ~clk;
end
endmodule