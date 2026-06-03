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
    initial begin //bloco com atribuiÇoes bloqueantes
        clk = 0; // Começa em baixo
        memoryWrite=0;
        memoryRead=0;
        memoryWriteData = 0;
        memoryAddress = 0;
    end

    always begin
        #5 clk = ~clk; // Inverte a cada 5ns (Gera um período completo de 10ns)
    end
initial begin //bloco de estimulos onde é necessario utilizar atribuiçao n bloqueante
    
        $fsdbDumpfile("teste_memory.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_memory);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]

    #15;
    
    memoryWriteData<=16'd2;
    memoryAddress<=8'd10;
    @(posedge clk);

    memoryWrite<=1;
    @(posedge clk);    
    
    memoryWrite<=0;
    @(posedge clk);           

    memoryRead<=1;
    @(posedge clk);    

    memoryAddress <= 8'd5; 
    @(posedge clk);

    #10;
    $finish;
end 
endmodule