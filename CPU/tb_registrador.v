module tb_registrador;
    parameter WIDTH=8; 
    reg clk,rst,en;
    reg [WIDTH-1:0] D;
    wire [WIDTH-1:0] Q;

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
        D=8'd10;
    end

    always begin
        #5 clk = ~clk; // Inverte a cada 5ns (Gera um período completo de 10ns)
    end
initial begin
    
        $fsdbDumpfile("teste_registrador.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_registrador);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]

    #15;

    rst=0;
    @(posedge clk);    
    
    en=1;
    @(posedge clk);           

    en=0;
    D=8'd20;
    @(posedge clk);   

    #10; 

    $finish;
end 
endmodule