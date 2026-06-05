`timescale 1ns/1ps

module tb_top;

    // 1. Parâmetro de Largura (Idêntico ao do módulo TOP)
    parameter WIDTH = 8;

    // 2. Declaração de Sinais do Testbench
    reg clk;
    reg rst;
    reg [6:0] cmdin;
    reg [WIDTH-1:0] din_1;
    reg [WIDTH-1:0] din_2;
    reg [WIDTH-1:0] din_3;

    wire [WIDTH-1:0] dout_low;
    wire [WIDTH-1:0] dout_high;
    wire cpu_rdy;
    wire zero;
    wire error;

    // 3. Instanciação do Módulo TOP (UUT - Unit Under Test)
    top #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .cmdin(cmdin),
        .din_1(din_1),
        .din_2(din_2),
        .din_3(din_3),
        .dout_low(dout_low),
        .dout_high(dout_high),
        .cpu_rdy(cpu_rdy),
        .zero(zero),
        .error(error)
    );

    // 4. Gerador de Relógio Principal (Período de 10ns)
    always begin
        #5 clk = ~clk;
    end

    // 5. Bloco de Estímulos e Execução do Programa
    initial begin
        // Configuração de gravação de arquivos de onda para o Verdi
        $fsdbDumpfile("top_processor.fsdb");
        $fsdbDumpvars(0, tb_top);

        // Inicialização de todas as variáveis no tempo zero
        clk = 0;
        rst = 1;
        cmdin = 7'b0000000;
        din_1 = 8'd0;
        din_2 = 8'd0;
        din_3 = 8'd0;

        // Mantém o processador em Reset por 2 ciclos completos para limpar os Flip-Flops
        #20;
        @(negedge clk);
        rst = 0; // Libera o processador para rodar
        $display("[TB_TOP] Processador inicializado e saindo do Reset.");

        // Configura valores padrão nas entradas físicas de dados
        din_1 = 8'd15; // Dado A primário
        din_2 = 8'd10; // Dado B primário
        din_3 = 8'd42; // Será usado como o Endereço de Memória RAM

        // ====================================================================
        // INSTRUÇÃO 1: SOMA (ADD) -> din_1 + din_2 (15 + 10 = 25)
        // Mux A = 2'b00 (din_1), Mux B = 2'b01 (din_2), Opcode = 3'b000
        // Binário do Comando: 2'b00 + 2'b01 + 3'b000 = 7'b00_01_000
        // ====================================================================
        $display("[TB_TOP] Injetando Instrucao 1: ADD (15 + 10)");
        cmdin = 7'b00_01_000;
        
        // Espera de forma síncrona a Unidade de Controle terminar e ligar o 'cpu_rdy'
        @(posedge cpu_rdy);
        @(negedge clk); // Dá um passo de meio ciclo para estabilizar a onda antes do próximo comando

        // ====================================================================
        // INSTRUÇÃO 2: GRAVAR NA RAM (STORE) -> Salva o resultado anterior (25) no endereço 42
        // Mux A = 2'b10 (din_3 atua como endereço), Mux B = 2'b00, Opcode = 3'b110
        // Binário do Comando: 2'b10 + 2'b00 + 3'b110 = 7'b10_00_110
        // ====================================================================
        $display("[TB_TOP] Injetando Instrucao 2: STORE (Salva 25 no endereco RAM 42)");
        cmdin = 7'b10_00_110;
        
        @(posedge cpu_rdy);
        @(negedge clk);

        // Limpa as entradas externas din_1 e din_2 para provar no Verdi
        // que o próximo dado virá puramente de dentro da memória!
        din_1 = 8'd0;
        din_2 = 8'd0;

        // ====================================================================
        // INSTRUÇÃO 3: LER DA RAM (LOAD) -> Resgata o valor armazenado no endereço 42
        // Mux A = 2'b10 (din_3 como endereço), Mux B = 2'b00, Opcode = 3'b101
        // Binário do Comando: 2'b10 + 2'b00 + 3'b101 = 7'b10_00_101
        // ====================================================================
        $display("[TB_TOP] Injetando Instrucao 3: LOAD (Busca dado do endereco RAM 42)");
        cmdin = 7'b10_00_101;
        
        @(posedge cpu_rdy);
        @(negedge clk); // Neste ponto, dout_low/dout_high exibem o valor 25 resgatado!

        // ====================================================================
        // INSTRUÇÃO 4: REALIMENTAÇÃO (FEEDBACK LOOP) -> soma dout_high com din_3 (25 + 42 = 67)
        // Mux A = 2'b11 (dout_high), Mux B = 2'b10 (din_3), Opcode = 3'b000
        // Binário do Comando: 2'b11 + 2'b10 + 3'b000 = 7'b11_10_000
        // ====================================================================
        $display("[TB_TOP] Injetando Instrucao 4: ADD com Malha de Realimentacao (dout_high + din_3)");
        cmdin = 7'b11_10_000;
        
        @(posedge cpu_rdy);
        @(negedge clk);

        // ====================================================================
        // INSTRUÇÃO 5: OPERAÇÃO NULA (NOP) -> Finaliza colocando a CPU em repouso
        // Opcode = 3'b111
        // ====================================================================
        $display("[TB_TOP] Injetando Instrucao 5: NOP (Fim do programa)");
        cmdin = 7'b00_00_111;
        
        @(posedge cpu_rdy);
        #20; // Tempo final extra para o Verdi capturar a estabilização completa do chip

        $display("[TB_TOP] Execucao do programa multiciclo concluida com sucesso total!");
        $finish;
    end

endmodule