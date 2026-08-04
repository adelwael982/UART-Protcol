module  tx #(parameter  w=8)(
   input par_en,par_type,data_valid,clk,rst,
   input [w-1:0] p_data,
   output txout,busy 
);
wire ser_en,ser_done,par_bit;
wire ser_data;
wire [1:0] mux_sel;
serializer #(.w(w)) d0(
.rst(rst),
.clk(clk),
.ser_en(ser_en),
.p_data(p_data),
.ser_done(ser_done),
.ser_data(ser_data)
);
fsm d1(
.rst(rst),
.clk(clk),
.ser_done(ser_done),
.par_en(par_en),
.busy(busy),
.mux_sel(mux_sel),
.data_valid(data_valid),
.ser_en(ser_en)
);
parity_calc #(.w(w)) d2(
.rst(rst),
.clk(clk),
.p_data(p_data),
.data_valid(data_valid),
.par_type(par_type),
.par_bit(par_bit)
);
mux d3(
.mux_sel(mux_sel),
.ser_data(ser_data),
.par_bit(par_bit),
.out(txout)
);

endmodule