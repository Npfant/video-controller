module clk_div #(parameter WIDTH = 3)(
    input logic clk,
    input logic rst,
    output logic clk_pix,
    output logic clk_pix_10x,
    output logic clk_pix_locked
);

    parameter MULTI_MASTER = 12.5875;
    
    /*if(WIDTH == 3) begin
        MULTI_MASTER = 74.25;
    end else if (WIDTH == 2) begin
        MULTI_MASTER = 37.125;
    end else begin
        MULTI_MASTER = 12.5875;
    end*/
    localparam DIV_MASTER = 5;
    localparam DIV_10x = 2.0;
    localparam DIV_1X = 10;
    localparam IN_PERIOD = 10.0;

    logic feedback;
    logic clk_pix_unbuf;
    logic clk_pix_10x_unbuf;
    logic locked;

    MMCME2_BASE #(
        .CLKBOUT_MULT_F(MULTI_MASTER),
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