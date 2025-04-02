module stimulus();

logic clk, clk_10x, rst, ch0_p, ch0_n, ch1_p, ch1_n, ch2_p, ch2_n, chc_p, chc_n;
logic [1:0] res;
logic [23:0] dataIn;
logic [24:0] cycle;

initial begin
    clk = 1;
    clk_10x = 1;
    rst = 1;
    res = 0;
    #2
    rst = 0;
end

vidya test(
    clk, clk_10x, clk_10x, rst, res, dataIn, ch0_p, ch0_n, ch1_p, ch1_n, ch2_p, ch2_n, chc_p, chc_n
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