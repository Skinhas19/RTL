module tb_mux4;
    parameter WIDTH=8; 
    reg [WIDTH-1:0] din1,din2,din3,din4;
    reg [1:0] select;
    wire [WIDTH-1:0] dout;

    mux4 #(WIDTH) uut (
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .din4(din4),
        .select(select),
        .dout(dout)
    );
initial begin
    
        $fsdbDumpfile("teste_mux.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_mux4);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]

        din1=8'd5;
        din2=8'd10;
        din3=8'd15;
        din4=8'd20;        

    select = 2'b00; // Seleciona din1
    #10;            // Espera 10 nanosegundos (A saída 'dout' deve virar 10)
    
    select = 2'b01;
    #10;           

    select = 2'b10;
    #10;    

    select = 2'b11;
    #10;        

    select=2'bx;
    #10;   
    $finish;
end 
endmodule