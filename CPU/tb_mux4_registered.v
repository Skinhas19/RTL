module tb_mux4_registered;

    parameter WIDTH=8; 
    reg clk,rst,wr_en;
    reg [1:0] sel;
    reg [WIDTH-1:0] in1,in2,in3,in4;
    wire [WIDTH-1:0] out;
    mux4_registered #(WIDTH) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .sel(sel),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out(out)
    );
    initial begin
        clk = 0; // Começa em baixo
        rst=0;
        wr_en=0;
        sel=2'b00;
        in1=8'd10;
        in2=8'd20;
        in3=8'd30;
        in4=8'd40;
    end

    always begin
        #5 clk = ~clk; // Inverte a cada 5ns (Gera um período completo de 10ns)
    end
initial begin
    
        $fsdbDumpfile("teste_mux4_registered.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_mux4_registered);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]
    

    #10;

    
    
    sel<=2'b00;
    @(negedge clk);

    sel<=2'b01;
    wr_en<=1;
    @(negedge clk);   
    
    sel<=2'b10;
    @(negedge clk);  

    sel<=2'b11;
    wr_en<=0;
    @(negedge clk);

    rst<=1;
    @(negedge clk);

    rst<=0;
    wr_en<=1;
    sel<=2'bx;
    @(negedge clk);

    #10;

    $finish;
end 
endmodule