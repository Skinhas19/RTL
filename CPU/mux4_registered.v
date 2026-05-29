module mux4_registered #(parameter WIDTH=8)
(
input wire clk,
input wire rst,
input wire wr_en,
input wire [1:0] sel,
input wire [WIDTH-1:0] in1,in2,in3,in4,
output reg [WIDTH-1:0] out 
);

always @(posedge clk) begin

    if(rst) begin
    
    out<=0;
    
    end
    else begin
    if(wr_en) begin

    case(sel)
    2'b00:out<=in1;
    2'b01:out<=in2;
    2'b10:out<=in3;
    2'b11:out<=in4;
    default: out<=0;
    endcase
    end
    end

end

endmodule
