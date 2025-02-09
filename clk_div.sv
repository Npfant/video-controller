module clk_div #(parameter WIDTH = 3)(
    input logic clk,
    input logic rst,
    output logic clk_pix,
    output logic clk_pix_5x,
    output logic clk_pix_5x,
    output logic clk_pix_locked
);

    if(WIDTH == 3) begin
        parameter MULTI_MASTER = 74.25;
    end else if (WIDTH == 2) begin
        parameter MULTI_MASTER = 37.125;
    end else begin
        parameter MULTI_MASTER = 12.5875;
    end
    parameter DIV_MASTER = 5;
    parameter DIV_5X = 2.0;
    parameter DIV_1X = 10;
    parameter IN_PERIOD = 10.0;

    logic feedback;
    logic clk_pix_unbuf;
    logic clk_pix_5x_unbuf;
    logic locked;

    MMCME2_BASE #(
        .CLKBOUT_MULT_F(MULTI_MASTER),
        .CLKIN1_PERIOD(IN_PERIOD),
        .CLKOUT0_DIVIDE_F(DIV_5X),
        .CLKOUT1_DIVIDE_F(DIV_1X,
        .DIV_CLK_DIVIDE(DIV_MASTER)
    ) MMCME2_BASE_inst (
        .CLKIN1(clk),
        .RST(rst),
        .CLKOUT0(clk_pix_5x_unbuf),
        .CLKOUT1(clk_pix_unbuf),
        .LOCKEDlocked),
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
        CLKFBOUTB(),
        .PWRDWN()
    );

    BUFG bufg_clk(.I(clk_pix_unbuf), .O(clk_pix));
    BUFG bufg_clk_5x(.I(clk_pix_5x_unbuf), .O(clk_pix_5x));

    logic locked_sync_0;
    always_FF @(posedge clk_pix) begin
        locked_sync_0 <= locked;
        clk_pix_locked<= locked_sync_0;
    end
endmodule