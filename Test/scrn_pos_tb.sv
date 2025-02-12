module stimulus();

logic clk;
logic rst;
logic [9:0] sx;
logic [9:0] sy;
logic hsync;
logic vsync;
logic de;

initial begin
    clk = 1;
    rst = 1;

    #2
    rst = 0;

end

scrn_pos test(
    clk, rst, sx, sy, hsync, vsync, de
);

always
    #1 clk = ~clk;

endmodule