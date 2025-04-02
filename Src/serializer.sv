module serializer(
    input logic clk,
    input logic x_clk,
    input logic rst,
    input logic [9:0] data,
    output logic serialized
);

    logic [9:0] temp;
    logic [4:0] i;
    logic [2:0] j;

    always_ff @(posedge x_clk) begin
        if (rst) begin
            i <= -1;
        end
        else begin
            case(i)
                0: serialized <= temp[0];
                1: serialized <= temp[1];
                2: serialized <= temp[2];
                3: serialized <= temp[3];
                4: serialized <= temp[4];
                5: serialized <= temp[5];
                6: serialized <= temp[6];
                7: serialized <= temp[7];
                8: serialized <= temp[8];
                9: serialized <= temp[9];
                default: serialized <= 0;
            endcase
            i <= i + 1;
            if(i == 5'b01001) begin
                i <= 0;
            end
        end
    end

    /*always_ff @(negedge x_clk) begin
        if (rst) begin
            j <= -1;
        end
        else begin
            case(j)
                0: serialized <= temp[0];
                1: serialized <= temp[2];
                2: serialized <= temp[4];
                3: serialized <= temp[6];
                4: serialized <= temp[8];
                default: serialized <= 0;
            endcase
            j <= j + 1;
            if(j == 3'b101) begin
                j <= 0;
            end
        end
    end*/

    always_ff @(posedge clk) begin
        temp <= data;
    end

endmodule
