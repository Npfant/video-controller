module top(
    input logic clk,
    input rst,
    input logic [23:0] dataIn,
    output logic ch0,
    output logic ch1,
    output logic ch2,
    output logic chc
);

localparam length = 10;
localparam WIDTH = 640;
localparam HEIGHT = 480;
localparam totPix = WIDTH * HEIGHT;
localparam addrLength = $clog2(totPix);

logic clk_pix, clk_10x, clk_pix_locked;
logic [length - 1 : 0] sx, sy;
logic hsync, vsync;
logic de, we;
logic [23:0] buffIn;
logic [addrLength-1:0] writeAddr, readAddr;

//Clock generator 
clk_div clk_gen(clk, rst, clk_pix, clk_10x, clk_pix_locked);

//Generate screen position signals
scrn_pos pos(clk_pix, rst, sx, sy, hsync, vsync, de);

always_ff @(posedge clk_pix) begin
    //Check to see if in the active region
    if(sx > 47) begin
        if(sx < 680) begin
            if(sy > 32) begin
                if(sy < 513) begin
                    we <= 1;
                end else begin
                    we <= 0;
                end
            end else begin
                we <= 0;
            end
        end else begin
            we <= 0;
        end
    end else begin
        we <= 0;
    end
    //Calculate write address within the frame buffer
    writeAddr <= WIDTH * sy + sx;
    if(sx == 0 && sy == 0) begin
        readAddr <= 0;
    end else if (we) begin
        readAddr <= readAddr + 1;
    end
end

//Framebuffer
vram framebuffer(clk_pix, clk_pix, we, writeAddr, readAddr, dataIn, buffIn);

//DVI encoder and generator
dvi_generator gen(clk_pix, clk_10x, rst, de, buffIn[7:0], {hsync, vsync}, buffIn[15:8], 2'b00, buffIn[23:16], 2'b00, ch0, ch1, ch2, chc);

endmodule