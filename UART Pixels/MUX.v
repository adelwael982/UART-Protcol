module mux (
    input  wire [1:0] mux_sel,
    input  wire ser_data,par_bit,
    output reg out
);

always @(*) begin
    case (mux_sel)
        2'b00: out = 1'b1;
        2'b01: out = 1'b0;
        2'b10: out = ser_data;
        2'b11: out = par_bit;
        default: out = 1'b1; 
    endcase
end

endmodule
