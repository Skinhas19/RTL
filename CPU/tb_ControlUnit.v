`timescale 1ns/1ps

module tb_control;

    // 1. Declaração de Sinais para Conectar no DUV (Design Under Test)
    reg clk;
    reg rst;
    reg [6:0] cmd_in;
    reg p_error;

    wire aluin_reg_en;
    wire datain_reg_en;
    wire memoryWrite, memoryRead, selmux2;
    wire cpu_rdy, aluout_reg_en, invalid_data;
    wire [1:0] in_select_a, in_select_b;
    wire [3:0] opcode;

    // 2. Instanciação do Módulo de Controle (Sem usar caractere #)
    control uut (
        .clk(clk),
        .rst(rst),
        .cmd_in(cmd_in),
        .p_error(p_error),
        .aluin_reg_en(aluin_reg_en),
        .datain_reg_en(datain_reg_en),
        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .selmux2(selmux2),
        .cpu_rdy(cpu_rdy),
        .aluout_reg_en(aluout_reg_en),
        .invalid_data(invalid_data),
        .in_select_a(in_select_a),
        .in_select_b(in_select_b),
        .opcode(opcode)
    );

    // 3. Gerador de Relógio (Clock com período de 10ns)
    always begin
        #5 clk = ~clk;
    end

    // 4. Bloco de Estímulos Principal
    initial begin
        // Configuração inicial para gravação de ondas no Verdi
        $fsdbDumpfile("control.fsdb");
        $fsdbDumpvars(0, tb_control);

        // Inicialização dos registradores do testbench
        clk = 0;
        rst = 1;
        cmd_in = 7'b0000000;
        p_error = 0;

        // --- TESTE 1: Sequência de Reset ---
        #15;
        rst = 0; // Libera o circuito do reset
        @(negedge clk);
        
        // --- TESTE 2: Instrução ADD (Opcode 3'b000) ---
        // Mux A = 2'b00, Mux B = 2'b01, Opcode = 3'b000 -> cmd_in = 7'b00_01_000
        $display("[TB] Injetando instrucao: ADD");
        cmd_in = 7'b00_01_000; 
        
        // Espera a instrução passar por FETCH, EXECUTE e atingir o STORE (cpu_rdy = 1)
        @(posedge cpu_rdy);
        @(negedge clk); // Aguarda um ciclo para estabilizar

        // --- TESTE 3: Instrução NOP (Opcode 3'b111) ---
        // Muxes não importam, Opcode = 3'b111 -> cmd_in = 7'b00_00_111
        $display("[TB] Injetando instrucao: NOP");
        cmd_in = 7'b00_00_111;
        
        @(posedge cpu_rdy);
        @(negedge clk);

        // --- TESTE 4: Instrução LOAD (Opcode 3'b101) ---
        // Mux A = 2'b10, Mux B = 2'b00, Opcode = 3'b101 -> cmd_in = 7'b10_00_101
        $display("[TB] Injetando instrucao: LOAD");
        cmd_in = 7'b10_00_101;
        
        @(posedge cpu_rdy);
        @(negedge clk);
        // --- TESTE 5: Instrução STORE (Opcode 3'b110) ---
        // Mux A = 2'b01, Mux B = 2'b10, Opcode = 3'b110 -> cmd_in = 7'b01_10_110
        $display("[TB] Injetando instrucao: STORE");
        cmd_in = 7'b01_10_110;
        
        @(posedge cpu_rdy);
       @(negedge clk);

        // --- TESTE 6: Condição de Erro no Loop de Feedback (invalid_data) ---
        // Força p_error em alto e manda ler do canal de feedback (Mux A = 2'b11)
        $display("[TB] Testando Condicao de Erro com Mux em Feedback");
        p_error = 1;
        cmd_in = 7'b11_00_000; // Mux A = 2'b11, Opcode = 3'b000
        
        #10; // Aguarda tempo combinacional para verificar a flag de dados inválidos
        if (invalid_data) begin
            $display("[TB] SUCESSO: Alerta de dados invalidos ativado corretamente!");
        end else begin
            $display("[TB] ERRO: O circuito nao detectou a falha de feedback.");
        end

        // Finaliza a simulação
        #20;
        $display("[TB] Todos os testes concluidos. Abrindo ondas no Verdi...");
        $finish;
    end

endmodule