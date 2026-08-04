`timescale 1ns/1ns

module tx_tb;
reg [7:0] p_datatb;
 reg par_entb;
 reg par_typetb;
 reg data_validtb;
 reg clk_tb;
 reg rst_tb;
 wire txout_tb;
 wire busy_tb; 
tx #(.w(8))dut (
 .p_data(p_datatb),
 .par_en(par_entb),
 .par_type(par_typetb),
 .data_valid(data_validtb),
 .clk(clk_tb),
 .rst(rst_tb),
.txout(txout_tb),
.busy(busy_tb) 
);

always #5	clk_tb=~clk_tb;
task send_byte;
input [7:0] data;
input parity_en;
input parity_type;
begin
    @(posedge clk_tb);
    p_datatb      = data;
    par_entb      = parity_en;
    par_typetb    = parity_type;
    data_validtb  = 1;

    @(posedge clk_tb);   // keep high for 1 cycle
    data_validtb  = 0;
    wait(busy_tb == 1);
    wait(busy_tb == 0);
    @(posedge clk_tb); 
end
endtask
initial begin
    $dumpfile("tx_vcd.vcd");
    $dumpvars;

    // Initial values
    clk_tb        = 0;
    rst_tb        = 0;
    data_validtb  = 0;
    p_datatb      = 0;
    par_entb      = 0;
    par_typetb    = 0;
//reset
    #20;
    rst_tb = 1;
    // Test 1: No Parity
    $display("Test 1: No Parity");
    send_byte(8'h1A, 0, 0);
    #20
    // Test 2: Even Parity
    $display("Test 2: Even Parity");
    send_byte(8'h1B, 1, 0);
    #20
    // Test 3: Odd Parity
    $display("Test 3: Odd Parity");
    send_byte(8'h1B, 1, 1);
    #20
    //Test 4:Check if data_valid is off what will be the output
    data_validtb=0;
    p_datatb=8'h1b;
    if(txout_tb==1) begin
       $display("Test 4 : data isnt valid : Passed");
    end
    else begin
       $display("Test 4 : data isnt valid : Failed");
    end
    #20
    #100;
    $display("Simulation Finished");
    $stop;
end
initial begin
    $monitor("Time=%0t | TX=%b | BUSY=%b",
              $time, txout_tb, busy_tb);
end


endmodule
