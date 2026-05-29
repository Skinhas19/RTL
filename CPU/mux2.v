module mux2 #(parameter WIDTH = 8)
(
input wire [2*WIDTH-1:0] din1,din2,
input wire select,
output reg [2*WIDTH-1:0] dout
);

always @(*) begin

    case(select)
    1'b0 : dout=din1;
    1'b1 : dout=din2;
    default:dout =0;
    endcase

end
endmodule