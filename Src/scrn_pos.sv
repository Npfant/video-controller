module scrn_pos (
    input logic clk_pix,
    input logic rst_pix,
    input logic [1:0] res,
    output logic [19:0] sx,
    output logic [19:0] sy,
    output logic hsync,
    output logic vsync,
    output logic de
);

    logic [19:0] H_ACT;
    logic [19:0] H_FP;
    logic [19:0] H_S;
    logic [19:0] H_TOT;
    logic [19:0] V_ACT;
    logic [19:0] V_FP;
    logic [19:0] V_S;
    logic [19:0] V_TOT;

    always_ff @(posedge clk_pix) begin
        H_ACT <= (res == 2) ? 1279 : (res == 1) ? 1919 : 639;
        H_FP <= (res== 2) ? (H_ACT + 110) : (res == 1) ? (H_ACT + 88) : (H_ACT + 16);
        H_S <= (res == 2) ? (H_FP + 40) : (res == 1) ? (H_FP + 44) : (H_FP + 96);
        H_TOT <= (res == 2) ? 1649 : (res == 1) ? 2199 : 799;
        V_ACT <= (res == 2) ? 719 : (res == 1) ? 1079 : 479;
        V_FP <= (res == 2) ? (V_ACT + 5) : (res == 1) ? (V_ACT + 4) : (V_ACT + 2);
        V_S <= (res == 2) ? (V_FP + 5) : (res == 1) ? (V_FP + 5) : (V_FP + 2);
        V_TOT <= (res == 2) ? 749 : (res == 1) ? 1124 : 524;
    end

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
