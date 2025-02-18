module stimulus();

logic clk, clk_10x, rst, ch0, ch1, ch2, chc;
logic [23:0] dataIn;
logic [24:0] cycle;

initial begin
    clk = 1;
    clk_10x = 1;
    rst = 1;
    #2
    rst = 0;
end

vidya test(
    clk, clk_10x, rst, dataIn, ch0, ch1, ch2, chc
);

always @ (posedge clk) begin
    if (rst) begin
        cycle <= 0;
        dataIn <= 0;
    end else begin
        cycle <= cycle + 1;
        dataIn <= cycle[23:0];
    end
end

always begin
    #1 clk_10x = ~clk_10x;
end

always begin
    #10 clk = ~clk;
end

endmodule