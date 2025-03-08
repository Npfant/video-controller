module stimulus();

logic clk;
logic rst;
logic [1:0] res;
logic [11:0] sx;
logic [11:0] sy;
logic hsync;
logic vsync;
logic de;

initial begin
    clk = 1;
    rst = 1;
    res = 0;

    #2
    rst = 0;

end

scrn_pos test(
    clk, rst, res, sx, sy, hsync, vsync, de
);

always
    #1 clk = ~clk;

endmodule