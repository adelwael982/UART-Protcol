module parity_calc #(parameter w = 8)(
  input clk,
  input rst,
  input data_valid,
  input [w-1:0] p_data,
  input  par_type,   // 0=even, 1=odd
  output reg  par_bit
);

wire even_par;
assign even_par = ^p_data;

always @(posedge clk or negedge rst) begin
  if (!rst)
    par_bit <= 1'b0;
  else if (data_valid) begin
    if (par_type== 1'b0)
      par_bit <= even_par;
    else
      par_bit <= ~even_par;
  end
end

endmodule

