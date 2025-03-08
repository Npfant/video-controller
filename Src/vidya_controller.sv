module vidya(
    input logic clk_pix,
    input logic clk_10x,
    input rst,
    input logic [1:0]  res,
    input logic [23:0] dataIn,
    output logic ch0,
    output logic ch1,
    output logic ch2,
    output logic chc
);

localparam WIDTH = 1280;
localparam HEIGHT = 720;
localparam totPix = WIDTH * HEIGHT;
localparam addrLength = $clog2(totPix);

logic [11 : 0] sx, sy;
logic hsync, vsync, hsync_buf1, vsync_buf1, hsync_buf2, vsync_buf2;
logic de, de_buf1, de_buf2;
logic [23:0] buffIn;
logic [addrLength-1:0] writeAddr, readAddr;


//Generate screen position signals
scrn_pos pos(clk_pix, rst, res, sx, sy, hsync, vsync, de);

always_ff @(posedge clk_pix) begin
    //Calculate write address within the frame buffer
    if(sx == 0 && sy == 0) begin
        writeAddr <= 0;
        readAddr <= 0;
    end else if (de) begin
        writeAddr <= writeAddr + 1;
        readAddr <= writeAddr;
    end
    de_buf1 <= de;
    de_buf2 <= de_buf1;
    hsync_buf1 <= hsync;
    hsync_buf2 <= hsync_buf1;
    vsync_buf1 <= vsync;
    vsync_buf2 <= vsync_buf1;
end

//Framebuffer
vram framebuffer(clk_pix, clk_pix, de, de, writeAddr, readAddr, dataIn, buffIn);

//DVI encoder and generator
dvi_generator gen(clk_pix, clk_10x, rst, de_buf2, buffIn[7:0], {hsync_buf2, vsync_buf2}, buffIn[15:8], 2'b00, buffIn[23:16], 2'b00, ch0, ch1, ch2, chc);

endmodule