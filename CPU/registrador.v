module registrador #(
    parameter WIDTH=8
) (
    input wire rst,
    input wire clk,
    input wire en,
    input wire [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q
);

always @(posedge clk)begin
    
    if(rst)begin
        Q<=0;
    end
    else begin
    if(en) begin
        Q<=D;
    end
    end
end
    
endmodule