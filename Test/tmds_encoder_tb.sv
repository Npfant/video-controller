module stimulus();

logic clk;
logic rst;
logic [7:0] data;
logic [1:0] ctrl;
logic de;
logic [9:0] tmds;
logic [9:0] cycle;

initial begin
    clk = 1;
    rst = 1;
    de = 0;
    ctrl = 2'b00;

    #10
    rst = 0;

    #10 de = 1;
end

tmds_encoder test(
    clk, rst, data, ctrl, de, tmds
);

always @ (posedge clk) begin
    if (rst) begin
        cycle <= 0;
        data <= 0;
    end
    else begin
        cycle <= cycle + 1;
        data <= cycle[7:0];
    end
end

always
    #5 clk = ~clk;

endmodule