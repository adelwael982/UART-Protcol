module rx #(parameter w = 8)(
    input clk,rst,rx_in,par_en,p_type,      // 0 = even, 1 = odd
    output wire [w-1:0] p_data,
    output wire data_valid,par_err,stop_err
);
wire [3:0] bit_cnt;
wire enable,deser_en,par_chk_en,stop_en;
wire data_sam;
assign data_sam = rx_in;
// Bit Counter
edge_bit d1(
.enable(enable),
.rst(rst),
.clk(clk),
.bit_cnt(bit_cnt)
);
// FSM
fsm_rx d2(
.clk(clk),
.rst(rst),
.par_err(par_err),
.stop_err(stop_err),
.par_en(par_en),
.rx_in(rx_in),
.bit_cnt(bit_cnt),
.par_chk_en(par_chk_en),
.stop_en(stop_en),
.enable(enable),
.deser_en(deser_en),
.data_valid(data_valid)
);
// Deserializer
deserializer #(w) d3(
.clk(clk),
.rst(rst),
.deser_en(deser_en),
.data_sam(data_sam),
.p_data(p_data)
);
// Parity Checker
parity_chk #(w) d4(
.clk(clk),
.rst(rst),
.par_chk_en(par_chk_en),
.p_type(p_type),
.data_sam(data_sam),
.par_err(par_err)
);
// Stop Bit Checker
stop_chk d5(
.clk(clk),
.rst(rst),
.stop_en(stop_en),
.data_sam(data_sam),
.stop_err(stop_err)
);

endmodule
