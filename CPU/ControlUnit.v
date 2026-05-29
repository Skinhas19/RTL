module control (
    input wire clk,
    input wire rst,
    input wire [6:0] cmd_in,
    input p_error,
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
    
case (current_state)
            
            RESET: begin
                
                datain_reg_en = 1; // Permite ler um novo comando
                
                // Se chegou um comando válido, vai para a próxima etapa
                if (opcode != 4'b0000) begin 
                    next_state = FETCH;
                end
                next_state=FETCH;
            end
            FETCH:begin
                aluin_reg_en=1;

            end

endcase

end



endmodule