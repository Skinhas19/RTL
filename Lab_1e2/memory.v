module memory#(parameter WIDTH=8)
(
    input wire clk,
    input wire memoryWrite,
    input wire memoryRead,
    input wire [2*WIDTH-1:0] memoryWriteData,
    input wire [WIDTH-1:0] memoryAddress,   
    output wire [2*WIDTH-1:0] memoryOutData //leitura assincrona, logo wire ao inves de reg
);

reg [2*WIDTH-1:0] ram [0:(2**WIDTH)-1]; //memoria com 255 posiçoes e com largura de 8

always @(posedge clk) begin

    if(memoryWrite) begin
        ram[memoryAddress]<=memoryWriteData;
    end

end

assign memoryOutData = (memoryRead) ? ram[memoryAddress] : 0;

endmodule