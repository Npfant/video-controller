module scrn_pos #(parameter WIDTH = 10)(
    input logic clk_pix,
    input logic rst_pix,
    output logic [(WIDTH - 1):0] sx,
    output logic [(WIDTH - 1):0] sy,
    output logic hsync,
    output logic vsync,
    output logic de
);

    localparam H_ACT = (WIDTH == 12) ? 1279 : (WIDTH == 14) ? 1919 : 639;
    localparam H_FP = (WIDTH == 12) ? (H_ACT + 110) : (WIDTH == 14) ? (H_ACT + 88) : (H_ACT + 16);
    localparam H_S = (WIDTH == 12) ? (H_FP + 40) : (WIDTH == 14) ? (H_FP + 44) : (H_FP + 96);
    localparam H_TOT = (WIDTH == 12) ? 1649 : (WIDTH == 14) ? 2199 : 799;
    localparam V_ACT = (WIDTH == 12) ? 719 : (WIDTH == 14) ? 1079 : 479;
    localparam V_FP = (WIDTH == 12) ? (V_ACT + 5) : (WIDTH == 14) ? (V_ACT + 4) : (V_ACT + 2);
    localparam V_S = (WIDTH == 12) ? (V_FP + 5) : (WIDTH == 14) ? (V_FP + 5) : (V_FP + 2);
    localparam V_TOT = (WIDTH == 12) ? 749 : (WIDTH == 14) ? 1124 : 524;

    always_comb begin
        hsync = ~(sx >= H_FP && sx < H_S);
        vsync = ~(sy >= V_FP && sy < V_S);
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
