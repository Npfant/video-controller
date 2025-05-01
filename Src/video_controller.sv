module video_controller(
    input logic clk,
    input logic rst,
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

logic clk_pix;
logic clk_5x;
logic locked;
logic hsync, vsync, de;
logic [9:0] SX, SY;

localparam WIDTH = 640;
localparam HEIGHT = 480;
logic[11:0] START_COLR = 12'h126;  // bar start colour (blue: 12'h126) (gold: 12'h640)
localparam COLR_NUM   = 10;       // colours steps in each bar (don't overflow)
localparam LINE_NUM   =  4;       // lines of each colour

logic [11:0] bar_colr;  // 12 bit colour (4 bits per channel)
logic bar_inc;  // increase (or decrease) brightness
logic [$clog2(COLR_NUM):0] cnt_colr;  // count colours in each bar
logic [$clog2(LINE_NUM):0] cnt_line;  // count lines of each colour
logic[5:0] count = 0;
clk_wiz_0 clk_wiz
 (
 // Clock out ports  
 .clk_out1(clk_5x),
 // Status and control signals               
 .reset(rst), 
 .locked(locked),
// Clock in ports
 .clk_in1(clk)
 );
  
clk_div clk_gen(.clk(clk_5x), .rst, .clk_pix);

scrn_pos scrn(.clk_pix(clk_pix), .rst, .res(2'b00), .sx(SX), .sy(SY), .hsync, .vsync, .de);

logic [7:0] count;

always_ff @(posedge clk_pix) begin
    if (SX == WIDTH) begin  // on each screen line at the start of blanking
        if (SY == HEIGHT-1) begin  // reset colour on last line of screen
            bar_colr <= START_COLR;
            bar_inc <= 1;  // start by increasing brightness
            cnt_colr <= 0;
            cnt_line <= 0 + count;
            if(count == 8'b111011111) begin
                count <= 8'b00000000;
               end else begin
                count <= count + 1;
            end
        end
        else if (cnt_line == LINE_NUM-1) begin  // colour complete
            cnt_line <= 0;
            if (cnt_colr == COLR_NUM-1) begin  // switch increase/decrease
                bar_inc <= ~bar_inc;
                cnt_colr <= 0;
            end else begin
                bar_colr <= (bar_inc) ? bar_colr + 12'h111 : bar_colr - 12'h111;
                cnt_colr <= cnt_colr + 1;
            end
        end else cnt_line <= cnt_line + 1;
    end
end

// separate colour channels
logic [3:0] paint_r, paint_g, paint_b;
always_comb {paint_r, paint_g, paint_b} = bar_colr;

// display colour: paint colour but black in blanking interval
logic [3:0] display_r, display_g, display_b;
always_comb begin
    display_r = (de) ? paint_r : 4'h0;
    display_g = (de) ? paint_g : 4'h0;
    display_b = (de) ? paint_b : 4'h0;
end

logic [7:0] dvi_r,dvi_g, dvi_b;
always_ff @(posedge clk_pix) begin
    //Calculate write address within the frame buffer
    dvi_r <= {2{display_r}};
    dvi_g <= {2{display_g}};
    dvi_b <= {2{display_b}};
end
logic [7:0] dvi_r,dvi_g, dvi_b;
always_ff @(posedge clk_pix) begin
    //Calculate write address within the frame buffer
    dvi_r <= {2{display_r}};
    dvi_g <= {2{display_g}};
    dvi_b <= {2{display_b}};
end

dvi_generator gen(.clk(clk_pix), .clk_5x, .rst, .de, .blu(dvi_b), .grn(dvi_g), .red(dvi_r), .ctrl0({vsync, hsync}), .ctrl1(2'b00), .ctrl2(2'b0), .ch0_p, .ch0_n, .ch1_p, .ch1_n, .ch2_p, .ch2_n, .chc_p, .chc_n);

endmodule


