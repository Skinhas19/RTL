module register_bank#(parameter WIDTH = 8)
(
input wire clk,
input wire rst,
input wire wr_en,
input wire [2:0] addr_rd,
input wire [2:0] addr_wr,
input wire [WIDTH-1:0] in,
output wire [WIDTH-1:0] out
);

reg [WIDTH-1:0] memoria [0:WIDTH-1];

integer i;

assign out=memoria[addr_rd];

always @(posedge clk) begin // quando é sincrono, atribuiçao tem q ser <=
    if(rst) begin
    for(i=0;i<WIDTH;i=i+1) begin
    memoria[i]<=0;
    end
    end
    else begin
    if (wr_en) begin
        memoria[addr_wr]<=in;
    end

    end
    
end

endmodule
