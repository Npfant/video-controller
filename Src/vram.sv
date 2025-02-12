module videoRam #(parameter DATAW = 24, totalWidth = 20, totalPixel = 307200)(
    input logic writeClk, readClk, writeEn, readEn,
    input logic [totalWidth-1:0] writePointer, readPointer,
    input logic [DATAW-1:0] dataIn,
    output logic [DATAW-1:0] dataOut
);
    logic [DATAW-1:0] buffMem [0:(totalPixel-1)];

    always_ff @(posedge writeClk) begin
        if(writeEn) begin
            buffMem[writePointer] <= dataIn;
        end
    end

    always_ff @(negedge readClk) begin
        if(readEn) begin
            dataOut <= buffMem[readPointer];
        end
    end
    
endmodule