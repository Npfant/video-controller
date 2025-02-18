module dvi_generator(
    input logic clk,
    input logic clk_10x,
    input logic rst,
    input logic de,
    input logic [7:0] blu,
    input logic [1:0] ctrl0,
    input logic [7:0] grn,
    input logic [1:0] ctrl1,
    input logic [7:0] red,
    input logic [1:0] ctrl2,
    output logic ch0,
    output logic ch1,
    output logic ch2,
    output logic chc
);

logic [9:0] tmds_ch0;
logic [9:0] tmds_ch1;
logic [9:0] tmds_ch2;

tmds_encoder encode_ch0 (clk, rst, blu, ctrl0, de, tmds_ch0);
tmds_encoder encode_ch1 (clk, rst, grn, ctrl1, de, tmds_ch1);
tmds_encoder encode_ch2 (clk, rst, red, ctrl2, de, tmds_ch2);

serializer serialize_ch0 (clk, clk_10x, rst, tmds_ch0, ch0);
serializer serialize_ch1 (clk, clk_10x, rst, tmds_ch1, ch1);
serializer serialize_ch2 (clk, clk_10x, rst, tmds_ch2, ch2);
serializer serialize_chc (clk, clk_10x, rst, 10'b0000011111, chc);

endmodule
