module serializer(
    input logic x_clk,
    input logic rst,
    input logic [9:0] data,
    output logic serialized
);

logic [3:0] TMDS_mod10=0;  // modulus 10 counter
logic [9:0] TMDS_shift=0;
logic TMDS_shift_load=0;
always @(posedge x_clk) TMDS_shift_load <= (TMDS_mod10==4'd9);

always @(posedge x_clk)
begin
	TMDS_shift <= TMDS_shift_load ? data   : TMDS_shift [9:1];	
	TMDS_mod10 <= (TMDS_mod10==4'd9) ? 4'd0 : TMDS_mod10+4'd1;
	serialized <= TMDS_shift[0];
end

endmodule
