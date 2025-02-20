module stimulus();

logic clk, clk_10x, rst, de, writeEn, readEn, ch0, ch1, ch2, chc;
logic [23:0] dataIn;
logic [24:0] cycle;

initial begin
    clk = 1;
    clk_10x = 1;
    writeEn = 1;
    readEn = 1;
    rst = 1;
    de = 0;
    #20
    rst = 0;
    #20
    de = 1;
end

dvi_generator test(
    clk, clk_10x, rst, de, dataIn[7:0], 2'b11, dataIn[15:8], 2'b00, dataIn[23:16], 2'b00, ch0, ch1, ch2, chc
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