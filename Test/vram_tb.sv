module stimulus();

logic clk, rst, writeEn, readEn;
logic [19:0] writePointer, readPointer;
logic [23:0] dataIn, dataOut;
logic [24:0] cycle;

initial begin
    clk = 1;
    writeEn = 1;
    readEn = 1;
    rst = 1;
    #2
    rst = 0;
end

videoRam test(
    clk, clk, writeEn, readEn, writePointer, readPointer, dataIn, dataOut
);

always @ (posedge clk) begin
    if (rst) begin
        cycle <= 0;
        dataIn <= 0;
        writePointer <= 0;
        readPointer <= 0;
    end
    else begin
        readPointer <= writePointer;
        cycle <= cycle + 1;
        dataIn <= cycle[23:0];
        writePointer <= cycle[23:0];
    end
end

always begin
    #1 clk = ~clk;
end


endmodule