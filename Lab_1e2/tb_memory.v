module tb_memory;

    parameter WIDTH=8; 
    reg clk,memoryWrite,memoryRead;
    reg [2*WIDTH-1:0] memoryWriteData;
    reg [WIDTH-1:0] memoryAddress;
    wire [2*WIDTH-1:0] memoryOutData;
    memory #(WIDTH) uut (
        .clk(clk),
        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryWriteData(memoryWriteData),
        .memoryAddress(memoryAddress),
        .memoryOutData(memoryOutData)
    );
    initial begin
        clk = 0; // Começa em baixo
        memoryWrite=0;
        memoryRead=0;

    end

    always begin
        #10 clk = ~clk; // Inverte a cada 5ns (Gera um período completo de 10ns)
    end
initial begin
    
        $fsdbDumpfile("teste_memory.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_memory);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]
    
    memoryWriteData=16'd2;
    memoryAddress=8'd10;
    #15;

    memoryWrite=1;
    #10;    
    
    memoryWrite=0;
    #10;           

    memoryRead=1;
    #10;    

    memoryAddress = 8'd5; 
    #10;

    $finish;
end 
endmodule