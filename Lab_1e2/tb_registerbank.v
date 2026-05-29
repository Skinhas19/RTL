module tb_registerbank;
    parameter WIDTH=8; 
    reg clk,rst,wr_en;
    reg [2:0] addr_rd,addr_wr;
    reg [WIDTH-1:0] in;
    wire [WIDTH-1:0] out;

    register_bank #(WIDTH) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .addr_rd(addr_rd),
        .addr_wr(addr_wr),
        .in(in),
        .out(out)    
    );
    initial begin
        clk = 0; // Começa em baixo
    end

    always begin
        #10 clk = ~clk; // Inverte a cada 5ns (Gera um período completo de 10ns)
    end
initial begin
    
        $fsdbDumpfile("teste_registerbank.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_registerbank);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]
    
    rst=1;
    wr_en=0;
    #15;

    rst=0;
    #10;    
    
    wr_en=1;
    in=8'd10;
    addr_wr=3'd2;
    #10;           

    wr_en=0;
    in=8'd20;
    addr_rd=3'd2;
    #10;    

    $finish;
end 
endmodule