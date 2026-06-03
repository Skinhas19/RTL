module top #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire rst,
    input wire [6:0] cmdin,
    input wire [WIDTH-1:0] din_1,
    input wire [WIDTH-1:0] din_2,
    input wire [WIDTH-1:0] din_3,
    output wire [WIDTH-1:0] dout_low,
    output wire [WIDTH-1:0] dout_high,
    output wire cpu_rdy,
    output wire zero,
    output wire error
);

    // ==========================================
    // 1. DECLARAÇÃO DOS FIOS INTERNOS (WIRES)
    // ==========================================
    
    // Fios vindos da Unidade de Controle
    wire aluin_reg_en, datain_reg_en, memoryWrite, memoryRead, selmux2;
    wire aluout_reg_en, invalid_data;
    wire [1:0] in_select_a, in_select_b;
    wire [3:0] opcode;
    
    // Fios do caminho de dados (Datapath)
    wire [6:0] cmd_reg_out;               // Saída do registrador de instrução
    wire [WIDTH-1:0] mux_a_out, mux_b_out; // Saídas dos MUXes de entrada
    wire [WIDTH-1:0] reg_a_out, reg_b_out; // Saídas dos registradores da ULA
    
    wire [(2*WIDTH)-1:0] alu_out;         // Saída de dados da ULA (Largura dupla)
    wire alu_zero, alu_error;             // Sinais de status diretos da ULA
    
    wire [(2*WIDTH)-1:0] mem_out;         // Saída de dados da Memória
    wire [(2*WIDTH)-1:0] mux2_out;        // Saída do MUX pós-ULA/Memória
    
    wire p_error_internal;                 // Feedback do erro registrado para a UC

    // Conecta os pinos de saída do chip aos fios internos correspondentes
    assign error = p_error_internal;

    // ==========================================
    // 2. INSTANCIAÇÃO DOS COMPONENTES
    // ==========================================

    // Registrador do Comando de Entrada (Página 12)
    // Salva o comando para não perdê-lo no próximo ciclo
    registrador #(.WIDTH(WIDTH)) reg_cmd (
        .clk(clk),
        .rst(rst),
        .en(datain_reg_en),
        .D(cmdin),
        .Q(cmd_reg_out)
    );

    // Unidade de Controle (O bloco que fizemos juntos!)
    control unidade_de_controle (
        .clk(clk),
        .rst(rst),
        .cmd_in(cmd_reg_out),
        .p_error(p_error_internal), // Feedback do erro anterior
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

    // Multiplexador A (Entradas da ULA)
    // Note que a quarta entrada (2'b11) recebe o feedback dout_high
    mux4_registered #(.WIDTH(WIDTH)) mux_A_e_Registrador_A (
        .clk(clk),
        .rst(rst),
        .wr_en(aluin_reg_en),
        .in1(din_1),
        .in2(din_2),
        .in3(din_3),
        .in4(dout_high), // Feedback loop
        .sel(in_select_a),
        .out(reg_a_out)
    );

    // Multiplexador B (Entradas da ULA)
    // A quarta entrada (2'b11) recebe o feedback dout_low
    mux4_registered #(.WIDTH(WIDTH)) mux_B_e_Registrador_B (
        .clk(clk),
        .rst(rst),
        .wr_en(aluin_reg_en),
        .in1(din_1),
        .in2(din_2),
        .in3(din_3),
        .in4(dout_low), // Feedback loop
        .sel(in_select_b),
        .out(reg_b_out)    
        
    );

    // Unidade Lógica e Aritmética (ALU)
    // Entradas têm largura WIDTH, saída tem largura 2*WIDTH
    ALU #(.WIDTH(WIDTH)) ULA (
        .in1(reg_a_out),
        .in2(reg_b_out),
        .op(opcode),
        .invalid_data(invalid_data),
        .out(alu_out),
        .zero(alu_zero),
        .error(alu_error)
    );

    // Memória RAM
    // Endereço vem do Reg A, Dado a gravar vem do Reg B
    memory #(.WIDTH(WIDTH)) memoria (
        .clk(clk),
        .memoryAddress(reg_a_out),
        .memoryWriteData({dout_high, dout_low}),
        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryOutData(mem_out)
    );

    // Multiplexador 2 (Seleciona entre ULA e Memória)
    // Esse MUX possui largura dupla (2*WIDTH)
    mux2 #(.WIDTH(WIDTH)) mux2_saida (
        .din1(alu_out),
        .din2(mem_out),
        .select(selmux2),
        .dout(mux2_out)
    );

    // Registrador de Saída Final (Gera dout_high e dout_low)
    registrador2 #(.WIDTH(WIDTH)) reg_out (
        .clk(clk),
        .rst(rst),
        .en(aluout_reg_en),
        .D(mux2_out),
        .Q({dout_high, dout_low}) // Divide a palavra de 16 bits ao meio
    );

      // Registrador de Status (Guarda o Zero e Erro da conta anterior)
    registrador #(.WIDTH(2)) reg_status (
        .clk(clk),
        .rst(rst),
        .en(aluout_reg_en),
        .D({alu_zero, alu_error}),
        .Q({zero, p_error_internal})
    );

endmodule