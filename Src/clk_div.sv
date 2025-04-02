module clk_div (
    input logic clk,
    input logic rst,
    output logic clk_pix
);

    logic [2:0] clk_count;

    always_ff @(posedge clk) begin
        if (rst) begin
	        clk_count <= 3'b0;
            clk_pix <= 1;
        end else if (clk_count == 4) begin
	        clk_pix <= ~clk_pix;
            clk_count <= 3'b0;
        end else begin
            clk_count <= clk_count + 1;
        end
    end

endmodule
