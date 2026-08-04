module uart #(parameter w = 8) (
    input clk,rst,
    // TX side
    input par_en,par_type,tx_data_valid,
    input  [w-1:0] p_data,
    output tx_out,busy,
    // RX side
    input rx_in,
    output [w-1:0] p_out_data,
    output rx_data_valid,par_err,stop_err
);
tx #(.w(w)) d1 (
.par_en(par_en),
.par_type(par_type),
.p_data(p_data),
.data_valid(tx_data_valid),
.clk(clk),
.rst(rst),
.busy(busy),
.txout(tx_out)
);
rx #(.w(w)) d2 (
.p_data(p_out_data),
.data_valid(rx_data_valid),
.par_err(par_err),
.stop_err(stop_err),
.clk(clk),
.rst(rst),
.rx_in(rx_in),
.p_type(par_type),
.par_en(par_en)
);

endmodule

