module control (
    input wire clk,
    input wire rst,
    input wire [6:0] cmd_in,
    input wire p_error,
    output reg aluin_reg_en,
    output reg datain_reg_en,
    output reg memoryWrite,memoryRead,selmux2,
    output reg cpu_rdy,aluout_reg_en,invalid_data,
    output reg [1:0] in_select_a,in_select_b,
    output reg [3:0] opcode
);
    //definiçao dos parametros da maquina de estado
    //2 bits de tamanho para ter 4 estados
    localparam RESET     = 2'd0; // Esperando comando
    localparam FETCH     = 2'd1; // Lendo as entradas
    localparam EXECUTE   = 2'd2; // Fazendo a conta na ULA
    localparam STORE     = 2'd3; // Salvando o resultado

    reg [1:0] current_state,next_state;

    wire [1:0]cmd_muxA=cmd_in[6:5];
    wire [1:0]cmd_muxB=cmd_in[4:3];
    wire [2:0]cmd_opcode=cmd_in[2:0];
    

    always @(posedge clk) begin
        if (rst) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end
always @(*) begin
    next_state = current_state;

    aluin_reg_en=0;
    datain_reg_en=0;
    memoryWrite=0;
    memoryRead=0;
    selmux2=0;
    cpu_rdy=0;
    aluout_reg_en=0;
    invalid_data=0;
    in_select_a=2'b00;
    in_select_b=2'b00;

    // Repassa o opcode de 3 bits estendido para 4 bits para a ULA
    opcode = {1'b0, cmd_opcode};
    invalid_data=(p_error&&(cmd_muxA==2'b11||cmd_muxB==2'b11));
case (current_state)
            
            RESET: begin
                
                datain_reg_en = 1; // Permite ler um novo comando
                // Se chegou um comando válido, vai para a próxima etapa
                next_state=FETCH;
            end

            FETCH:begin

                in_select_a = cmd_muxA; 
                in_select_b = cmd_muxB;

                if (cmd_opcode == 3'b100 || cmd_opcode == 3'b111) begin
                    aluin_reg_en = 0;
                end else begin
                    aluin_reg_en = 1;
                end
                next_state=EXECUTE;
            end

            EXECUTE: begin
                case(cmd_opcode)
                3'b000,3'b001,3'b010,3'b011: begin //ADD,SUB,MUL,DIV
                    aluout_reg_en=1;
                    selmux2=0;
                end
                3'b101: begin    //LOAD
                    memoryRead=1;
                    selmux2=1;
                    aluout_reg_en=1;
                end
                default: ;//STORE,NOP
            endcase
            next_state=STORE;
            end

            STORE: begin
                cpu_rdy=1;
                datain_reg_en=1;
                if(cmd_opcode==110)begin
                    memoryWrite=1;
                end
            next_state=FETCH;
            end
            default: next_state=RESET;
endcase
end



endmodule