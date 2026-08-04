module stop_chk (
    input wire clk, rst,
    input wire stop_en,
    input wire data_sam,
    output reg stop_err
);

always @(posedge clk or negedge rst) begin
    if(!rst)
        stop_err <= 0;
    else if(stop_en)
        stop_err <= !data_sam;
        
        else if (!stop_en) begin
            stop_err<=0;
        end
end
endmodule