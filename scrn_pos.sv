`timescale 1ns/1ps

module scrn_pos #(parameter WIDTH = 12)(
    input wire logic clk_pix,
    input wire logic rst_pix,
    output     logic [(WIDTH - 1):0] sx,
    output     logic [(WIDTH - 1):0] sy,
    output     logic hsync,
    output     logic vsync,
    output     logic de
);

    if (WIDTH == 12) begin
        parameter H_ACT = 1279;
        parameter H_FP = H_ACT + 110;
        parameter H_S = H_FP + 40;
        parameter H_TOT   = 1649;

        parameter V_ACT = 719;
        parameter V_FP = V_ACT + 5;
        parameter V_S = V_FP + 5;
        parameter V_TOT = 749;
    end else if (WIDTH == 14) begin
        parameter H_ACT = 1919;
        parameter H_FP = H_ACT + 88;
        parameter H_S = H_FP + 44;
        parameter H_TOT = 2199;

        parameter V_ACT = 1079;
        parameter V_FP = V_ACT + 4;
        parameter V_S = V_FP + 5;
        parameter V_TOT = 1124;
    end else begin
        parameter H_ACT = 639;
        parameter H_FP = H_ACT + 16;
        parameter H_S = H_FP + 96;
        parameter H_TOT = 799;

        parameter V_ACT = 479;
        parameter V_FP = V_ACT + 2;
        parameter V_S = V_FP + 2;
        parameter V_TOT = 524;
    end

    always_comb begin
        hsync = (H_FP <= sx && sx < H_S);
        vsync = (V_FP <= sy && sy < V_S);
        de = (sx <= H_ACT && sy <= V_ACT);
    end

    always_ff @(posedge clk_pix) begin
        if(sx == H_TOT) begin
            sx <= 0;
            sy <= (sy == V_TOT) ? 0 : sy + 1;
        end else begin
            sx <= sx + 1;
        end
        if (rst_pix) begin
            sx <= 0;
            sy <= 0;
        end
    end
endmodule
