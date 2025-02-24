module scrn_pos (
    input logic clk_pix,
    input logic rst_pix,
    input logic [1:0] RES,
    output logic [11:0] sx,
    output logic [11:0] sy,
    output logic hsync,
    output logic vsync,
    output logic de
);

    localparam H_ACT = (RES == 2'b01) ? 1279 : (RES == 2'b10) ? 1919 : 639;
    localparam H_FP = (RES == 2'b01) ? (H_ACT + 110) : (RES == 2'b10) ? (H_ACT + 88) : (H_ACT + 16);
    localparam H_S = (RES == 2'b01) ? (H_FP + 40) : (RES == 2'b10) ? (H_FP + 44) : (H_FP + 96);
    localparam H_TOT = (RES == 2'b01) ? 1649 : (RES == 2'b10) ? 2199 : 799;
    localparam V_ACT = (RES == 2'b01) ? 719 : (RES == 2'b10) ? 1079 : 479;
    localparam V_FP = (RES == 2'b01) ? (V_ACT + 5) : (RES == 2'b10) ? (V_ACT + 4) : (V_ACT + 2);
    localparam V_S = (RES == 2'b01) ? (V_FP + 5) : (RES == 2'b10) ? (V_FP + 5) : (V_FP + 2);
    localparam V_TOT = (RES == 2'b01) ? 749 : (RES == 2'b10) ? 1124 : 524;

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
