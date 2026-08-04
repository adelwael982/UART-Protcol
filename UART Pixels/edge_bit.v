module edge_bit (
    input enable,rst,clk,
    output reg  [3:0] bit_cnt  
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        bit_cnt <= 0;
    end
    else if (enable) begin
        if (bit_cnt == 9)
            bit_cnt <= 0;
        else
            bit_cnt <= bit_cnt + 1;
    end
    else begin 
        bit_cnt<=0;
    end
end

endmodule

