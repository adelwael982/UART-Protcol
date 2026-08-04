`timescale 1ns/1ns

module uart_tb;

parameter w = 8;


reg clk;
reg rst;

// TX side
reg par_en;
reg par_type;
reg tx_data_valid;
reg [w-1:0] p_data;
wire tx_out;
wire busy;

// RX side
wire [w-1:0] p_out_data;
wire rx_data_valid;
wire par_err;
wire stop_err;


wire rx_in = tx_out;


uart #(.w(w)) dut (
    .clk(clk),
    .rst(rst),

    .par_en(par_en),
    .par_type(par_type),
    .tx_data_valid(tx_data_valid),
    .p_data(p_data),
    .tx_out(tx_out),
    .busy(busy),

    .rx_in(rx_in),
    .p_out_data(p_out_data),
    .rx_data_valid(rx_data_valid),
    .par_err(par_err),
    .stop_err(stop_err)
);


always #5 clk = ~clk;

task send_byte;
    input [w-1:0] data;
begin
    @(negedge clk);
    p_data        = data;
    tx_data_valid = 1'b1;
    @(negedge clk);
    tx_data_valid = 1'b0;
end
endtask

task wait_rx;
begin
    wait (rx_data_valid);
    @(posedge clk); 
end
endtask

initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);

    clk = 0;
    rst = 0;

    par_en = 0;
    par_type = 0;
    tx_data_valid = 0;
    p_data = 0;

    // reset
    #20 rst = 1;

    // EVEN parity test
    par_en   = 1;
    par_type = 0; // even
    send_byte(8'hA5);
    wait_rx;

    if (p_out_data == 8'hA5 && !par_err && !stop_err)
        $display("PASS: Even parity");
    else
        $display("FAIL: Even parity");
    // ODD parity test
    par_en   = 1;
    par_type = 1; // odd
    send_byte(8'h3C);
    wait_rx;

    if (p_out_data == 8'h3C && !par_err && !stop_err)
        $display("PASS: Odd parity");
    else
        $display("FAIL: Odd parity");
    // NO parity test
    par_en = 0;
    send_byte(8'hFF);
    wait_rx;

    if (p_out_data == 8'hFF && !par_err && !stop_err)
        $display("PASS: No parity");
    else
        $display("FAIL: No parity");
end
endmodule
