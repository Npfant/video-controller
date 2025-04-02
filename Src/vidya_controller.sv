module vidya(
    input logic clk,
    input logic clk_640,
    input logic clk_1280,
    input logic rst,
    input logic [1:0]  res,
    input logic [23:0] dataIn,
    output logic ch0_p,
    output logic ch0_n,
    output logic ch1_p,
    output logic ch1_n,
    output logic ch2_p,
    output logic ch2_n,
    output logic chc_p,
    output logic chc_n
	);
  
localparam WIDTH = 1280;
localparam HEIGHT = 720;
localparam totPix = WIDTH * HEIGHT;
localparam addrLength = $clog2(totPix);

logic clk_pix, clk_5x;
logic [19:0] sx, sy;
logic hsync, vsync, hsync_buf1, vsync_buf1, hsync_buf2, vsync_buf2;
logic de, we, de_buf1, de_buf2;
logic [23:0] buffIn;
logic [addrLength - 1:0] writeAddr, readAddr;

assign clk_5x = (res == 1) ? clk_1280 : clk_640;

//Clock generator
clk_div clk_gen(clk_5x, rst, clk_pix);

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

localparam data = 24'h00B4FF;

//Framebuffer
//vram framebuffer(clk_pix, clk_pix, de, de, writeAddr, readAddr, data, buffIn);

//DVI encoder and generator
dvi_generator gen(clk_pix, clk_5x, rst, de, data[7:0], {hsync, vsync}, data[15:8], 2'b00, data[23:16], 2'b00, ch0_p, ch0_n, ch1_p, ch1_n, ch2_p, ch2_n, chc_p, chc_n);

endmodule