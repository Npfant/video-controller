module top(
    input logic clk,
    input logic rst,
    input logic [1:0]  res,
    input logic [23:0] dataIn,
    output logic ch0,
    output logic ch1,
    output logic ch2,
    output logic chc
);

//localparam 640_length = 10;
//localparam 640_WIDTH = 640;
//localparam 640_HEIGHT = 480;
//localparam 640_totPix = 640_WIDTH * 640_HEIGHT;
//localparam 640_addrLength = $clog2(640_totPix);

//localparam 1280_length = 12;
localparam 1280_WIDTH = 1280;
localparam 1280_HEIGHT = 720;
localparam 1280_totPix = 1280_WIDTH * 1280_HEIGHT;
localparam 1280_addrLength = $clog2(1280_totPix);

logic clk_pix, clk_10x, clk_pix_locked;
logic [11 : 0] sx, sy;
logic hsync, vsync;
logic de, we;
logic [23:0] buffIn;
logic [addrLength-1:0] writeAddr, readAddr;

//Clock generator 
clk_div clk_gen(clk, rst, res, clk_pix, clk_10x, clk_pix_locked);

//Generate screen position signals
scrn_pos pos(clk_pix, rst, res, sx, sy, hsync, vsync, de);

always_ff @(posedge clk_pix) begin
    //Check resolution to determine bounds
    if(res == 2'b01) begin
        //Check to see if in the active region
        if(sx > 219) begin
            if(sx < 1500) begin
                if(sy > 19) begin
                    if(sy < 740) begin
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
    end else begin
        if(sx > 47) begin
            if(sx < 688) begin
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
end

//Framebuffer
vram framebuffer(clk_pix, clk_pix, we, writeAddr, readAddr, dataIn, buffIn);

//DVI encoder and generator
dvi_generator gen(clk_pix, clk_10x, rst, de, buffIn[7:0], {hsync, vsync}, buffIn[15:8], 2'b00, buffIn[23:16], 2'b00, ch0, ch1, ch2, chc);

endmodule