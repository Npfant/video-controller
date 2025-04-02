module dvi_generator(
    input logic clk,
    input logic clk_5x,
    input logic rst,
    input logic de,
    input logic [7:0] blu,
    input logic [1:0] ctrl0,
    input logic [7:0] grn,
    input logic [1:0] ctrl1,
    input logic [7:0] red,
    input logic [1:0] ctrl2,
    output logic ch0_p,
    output logic ch0_n,
    output logic ch1_p,
    output logic ch1_n,
    output logic ch2_p,
    output logic ch2_n,
    output logic chc_p,
    output logic chc_n
);

logic [9:0] tmds_ch0;
logic [9:0] tmds_ch1;
logic [9:0] tmds_ch2;
logic ch0, ch1, ch2, chc;

tmds_encoder encode_ch0 (clk, rst, blu, ctrl0, de, tmds_ch0);
tmds_encoder encode_ch1 (clk, rst, grn, ctrl1, de, tmds_ch1);
tmds_encoder encode_ch2 (clk, rst, red, ctrl2, de, tmds_ch2);

serializer serialize_ch0 (clk, clk_5x, rst, tmds_ch0, ch0);
serializer serialize_ch1 (clk, clk_5x, rst, tmds_ch1, ch1);
serializer serialize_ch2 (clk, clk_5x, rst, tmds_ch2, ch2);
serializer serialize_chc (clk, clk_5x, rst, 10'b0000011111, chc);

differential differential_ch0 (clk_5x, rst, ch0, ch0_p, ch0_n);
differential differential_ch1 (clk_5x, rst, ch1, ch1_p, ch1_n);
differential differential_ch2 (clk_5x, rst, ch2, ch2_p, ch2_n);
differential differential_chc (clk_5x, rst, chc, chc_p, chc_n);

endmodule
