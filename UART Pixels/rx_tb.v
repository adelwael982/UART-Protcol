`timescale 1ns/1ns
module rx_tb;

parameter w = 8;

reg clk_tb;
reg rst_tb;
reg rx_in_tb;
reg par_en_tb;
reg p_type_tb;

wire [w-1:0] p_data_tb;
wire data_valid_tb;
wire par_errtb;
wire stop_errtb;

rx #(.w(w)) d2 (
    .p_data(p_data_tb),
    .data_valid(data_valid_tb),
    .par_err(par_errtb),
    .stop_err(stop_errtb),
    .clk(clk_tb),
    .rst(rst_tb),
    .rx_in(rx_in_tb),
    .p_type(p_type_tb),
    .par_en(par_en_tb)
);

always #5 clk_tb = ~clk_tb;

task send_uart_frame;
    input [w-1:0] data;
    input         par_en;
    input         p_type;

    integer i;
    reg parity_bit;
begin
    par_en_tb = par_en;
    p_type_tb = p_type;

    //ignore start bit
    rx_in_tb = 1'b0;
    #10;

    // data bits 
    for (i = 0; i < w; i = i + 1) begin
        rx_in_tb = data[i];
        #10;
    end

    // parity bit
    if (par_en) begin
        parity_bit = ^data;
        if (p_type)
            parity_bit = ~parity_bit;

        rx_in_tb = parity_bit;
        #10;
    end

    // stop bit
    rx_in_tb = 1'b1;
    #10;

end
endtask
task send_false_stop;
    input [w-1:0] data;
    input         par_en;
    input         p_type;

    integer i;
    reg parity_bit;
begin
    par_en_tb = par_en;
    p_type_tb = p_type;

    // start bit
    rx_in_tb = 1'b0;
    #10;

    // data bits
    for (i = 0; i < w; i = i + 1) begin
        rx_in_tb = data[i];
        #10;
    end

    // parity bit
    if (par_en) begin
        parity_bit = ^data;
        if (p_type)
            parity_bit = ~parity_bit;

        rx_in_tb = parity_bit;
        #10;
    end

    // WRONG stop bit
    rx_in_tb = 1'b0;
    #10;

end

endtask
task send_false_parity;
    input [w-1:0] data;
    input         par_en;
    input         p_type;

    integer i;
    reg parity_bit;
begin
    par_en_tb = par_en;
    p_type_tb = p_type;

    //ignore start bit
    rx_in_tb = 1'b0;
    #10;

    // data bits 
    for (i = 0; i < w; i = i + 1) begin
        rx_in_tb = data[i];
        #10;
    end

    // parity bit
   if(par_en) begin
    parity_bit = ^data;
    if(p_type)
        parity_bit = ~parity_bit;
    parity_bit = ~parity_bit; 
    rx_in_tb = parity_bit;
    #10;
end

    // stop bit
    rx_in_tb = 1'b1;

end
endtask
initial begin
  $dumpfile("rx_tb.vcd");
  $dumpvars;

    clk_tb    = 0;
    rst_tb    = 0;
    rx_in_tb  = 1;
    par_en_tb = 0;
    p_type_tb = 0;

    #20 rst_tb = 1;

    send_uart_frame(8'hA5, 1'b1, 1'b0);//Even parity
   if (p_data_tb==8'hA5&&data_valid_tb) begin
    $display("Test Pass:Even parity");
   end
   else begin
    $display("Test Fail:Even parity");
   end#20;
    send_uart_frame(8'h3C, 1'b1, 1'b1);//Odd parity      
     if (p_data_tb==8'h3C&&data_valid_tb) begin
    $display("Test Pass:Odd parity");
   end
   else begin
    $display("Test Fail:Odd parity");
   end#20;
    send_uart_frame(8'hFF, 1'b0, 1'b0);//No parity
  if (p_data_tb==8'hFF&&data_valid_tb) begin
    $display("Test Pass:No parity");
   end
   else begin
    $display("Test Fail:No parity");
   end#20;
 
   send_false_parity(8'h3C, 1'b1, 1'b1);//Wrong parity bit if passed then parity error is working  
     if (!data_valid_tb&&par_errtb) begin
    $display("Test Pass: Parity error");
   end
   else begin
    $display("Test Fail: Parity error");
   end#20;
   send_false_stop(8'h3C, 1'b1, 1'b1);//Wrong stop bit if passed then stop error is working  
     if (stop_errtb&&!data_valid_tb) begin
    $display("Test Pass: Stop error");
   end
   else begin
    $display("Test Fail: Stop error");
   end#20;rx_in_tb=1;
    #100 $stop;
end

endmodule
