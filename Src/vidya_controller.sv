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

//Following is hard coded color gradient for 640 x 480
logic [3:0] paint_r, paint_g, paint_b;
always_comb begin
    if (SX < 640 && SY < 480) begin  // colour square in top-left 512x512 pixels
        paint_r = sx[8:5];  // 32 horizontal pixels of each red level
        paint_g = sy[8:5];  // 32 vertical pixels of each green level
        paint_b = 4'h4;     // constant blue level
    end else begin  // background colour
        paint_r = 4'h0;
        paint_g = 4'h1;
        paint_b = 4'h3;
    end
end

// display colour: paint colour but black in blanking interval
logic [3:0] display_r, display_g, display_b;
always_comb begin
    display_r = (de) ? paint_r : 4'h0;
    display_g = (de) ? paint_g : 4'h0;
    display_b = (de) ? paint_b : 4'h0;
end

// DVI signals (8 bits per colour channel)
logic [7:0] dvi_r, dvi_g, dvi_b;
logic dvi_hsync, dvi_vsync, dvi_de;
always_ff @(posedge clk_pix) begin
    dvi_hsync <= hsync;
    dvi_vsync <= vsync;
    dvi_de <= de;
    dvi_r <= {2{display_r}};  // double signal width from 4 to 8 bits
    dvi_g <= {2{display_g}};
    dvi_b <= {2{display_b}};
end

//Framebuffer
//vram framebuffer(clk_pix, clk_pix, de, de, writeAddr, readAddr, data, buffIn);

//DVI encoder and generator
dvi_generator gen(.clk(clk_pix), .clk_5x, .rst, .de, .blu(dvi_b), .grn(dvi_g), .red(dvi_r), .ctrl0({vsync, hsync}), .ctrl1(2'b00), .ctrl2(2'b0), .ch0_p, .ch0_n, .ch1_p, .ch1_n, .ch2_p, .ch2_n, .chc_p, .chc_n);

endmodule