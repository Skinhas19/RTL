module tb_registrador2;
    parameter WIDTH=8; 
    reg clk,rst,en;
    reg [2*WIDTH-1:0] D;
    wire [2*WIDTH-1:0] Q;

    registrador2 #(WIDTH) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .D(D),
        .Q(Q)    
    );

    initial begin
        clk = 0; // Começa em baixo
        en=0;
        rst=1;
        D=16'd10;
    end

    always begin
        #5 clk = ~clk; // Inverte a cada 5ns (Gera um período completo de 10ns)
    end
initial begin
    
    $fsdbDumpfile("teste_registrador2.fsdb"); // Cria o arquivo
    $fsdbDumpvars(0, tb_registrador2);       // Grava tudo do módulo tb_mux4
    //[Tamanho] ' [Base] [Valor]
    
    #10;

    rst=0;
    #10;    
    
    en=1;
    #10;           

    en=0;
    D=16'd20;
    #10;    

    $finish;

end 
endmodule