module vram #(parameter DATAW = 24, addrLength = 20, totalPixel = 921600)(
    input logic writeClk, readClk, writeEn, readEn,
    input logic [addrLength-1:0] writePointer, readPointer,
    input logic [DATAW-1:0] dataIn,
    output logic [DATAW-1:0] dataOut
);
    logic [31:0] buffMem [0:(totalPixel-1)];
    //logic [31:0] lol;

    always_ff @(posedge writeClk) begin
        if(writeEn) begin
            buffMem[writePointer-1] <= {8'b00000000, dataIn};
        end
    end

    always_ff @(posedge readClk) begin
        if(readEn) begin
            dataOut <= buffMem[readPointer-1][23:0];
        end
    end
    
endmodule
