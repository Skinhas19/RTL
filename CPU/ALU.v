module ALU#(parameter WIDTH=8)
(
    input wire [WIDTH-1:0] in1,in2,
    input wire [3:0] op,
    input wire invalid_data,
    output reg [2*WIDTH-1:0] out,
    output reg zero,
    output reg error
);


always @(*) begin //assincrono, atribuição pode ser =
error=0;
zero=0;
out=0;
if(invalid_data==1)begin
    error=1;
    out=-1;
end
else begin
case(op)
    4'b0000:out=in1+in2;
    4'b0001:out=in1-in2;
    4'b0010:out=in1*in2;
    4'b0011:begin 
        if(in2==0)begin
    error=1;
    out=-1;
    end
    else begin
        out=in1/in2;
    end
    end
    default: out=error;
endcase

if (out==0)begin
zero=1;
end
end
end

endmodule