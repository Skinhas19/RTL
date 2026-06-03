module tb_ALU;
    parameter WIDTH=8; 
    reg [WIDTH-1:0] in1,in2;
    reg [3:0] op;
    reg invalid_data;
    wire [2*WIDTH-1:0] out;
    wire zero,error;

    ALU #(WIDTH) uut (
        .in1(in1),
        .in2(in2),
        .op(op),
        .invalid_data(invalid_data),
        .out(out),
        .zero(zero),
        .error(error)    
    );
initial begin
    in1=8'd10;
    in2=8'd5;
    op=4'b0001;
    invalid_data=1;
end

initial begin
    
        $fsdbDumpfile("teste_ALU.fsdb"); // Cria o arquivo
        $fsdbDumpvars(0, tb_ALU);       // Grava tudo do módulo tb_mux4
        //[Tamanho] ' [Base] [Valor]

    
    #10;

    invalid_data=0;
    #10;    
    
    op=4'b0010;
    #10;           

    op=4'b0011;
    #10;    

    op=4'b0100;
    #10;

    in2=0;
    #10;

    op=4'b0000;
    #10;

    in2=8'd10;
    op=4'b0010;
    #10;


    $finish;
end 
endmodule