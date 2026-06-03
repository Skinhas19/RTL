module tb_mux2;
    parameter WIDTH=8; 
    reg [2*WIDTH-1:0] din1,din2;
    reg select;
    wire [2*WIDTH-1:0] dout;

    mux2 #(WIDTH) uut (
        .din1(din1),
        .din2(din2),
        .select(select),
        .dout(dout)
    );
    initial begin
        din1=16'd5;
        din2=16'd10;
        select = 1'b0;
    end
initial begin
    
        $fsdbDumpfile("teste_mux2.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_mux2);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]

    #10;            // Espera 10 nanosegundos (A saída 'dout' deve virar 10)
    
    select = 1'b1;
    #10;                  

    select=1'bx;
    #10;
       
    $finish;
end 
endmodule