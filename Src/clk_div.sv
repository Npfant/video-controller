module clk_div (
    input logic clk,
    input logic rst,
    input logic [1:0] res,
    output logic clk_pix,
    output logic clk_pix_10x,
    output logic clk_pix_locked
);

    localparam MULTI_MASTER_640 = 12.5875;
    localparam MULTI_MASTER_1280 = 37.125;
    localparam DIV_MASTER = 5;
    localparam DIV_10x = 2.0;
    localparam DIV_1X = 10;
    localparam IN_PERIOD = 10.0;

    /*if(WIDTH == 3) begin
        MULTI_MASTER = 74.25; //1920x1080
    end else if (WIDTH == 2) begin
        MULTI_MASTER = 37.125; //1280x720
    end else begin
        MULTI_MASTER = 12.5875; //640x480
    end*/

    logic feedback;
    logic clk_pix_unbuf;
    logic clk_pix_10x_unbuf;
    logic locked;

    MMCME2_BASE #(
        .CLKBOUT_MULT_F(if(res == 2'b01) ? 37.125 : 12.5875),
        .CLKIN1_PERIOD(IN_PERIOD),
        .CLKOUT0_DIVIDE_F(DIV_10x),
        .CLKOUT1_DIVIDE_F(DIV_1X),
        .DIV_CLK_DIVIDE(DIV_MASTER)
    ) MMCME2_BASE_inst (
        .CLKIN1(clk),
        .RST(rst),
        .CLKOUT0(clk_pix_10x_unbuf),
        .CLKOUT1(clk_pix_unbuf),
        .LOCKED(locked),
        .CLKFBOUT(feedback),
        .CLKFBIN(feedback),
        .CLKOUT0B(),
        .CLKOUT1B(),
        .CLKOUT2B(),
        .CLKOUT3B(),
        .CLKOUT2(),
        .CLKOUT3(),
        .CLKOUT4(),
        .CLKOUT5(),
        .CLKOUT6(),
        .CLKFBOUTB(),
        .PWRDWN()
    );

    BUFG bufg_clk(.I(clk_pix_unbuf), .O(clk_pix));
    BUFG bufg_clk_10x(.I(clk_pix_10x_unbuf), .O(clk_pix_10x));

    logic locked_sync_0;
    always_ff @(posedge clk_pix) begin
        locked_sync_0 <= locked;
        clk_pix_locked<= locked_sync_0;
    end
endmodule