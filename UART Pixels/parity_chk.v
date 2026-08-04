module parity_chk #(parameter w = 8)(
    input  wire clk,rst,par_chk_en,
    input  wire p_type,     // 0 = even, 1 = odd
    input  wire data_sam,   // serial data bit
    output reg  par_err
);

reg [3:0] count;
reg par_acc;
reg par_en_d;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        par_acc  <= 0;
        par_err  <= 0;
        count    <= 0;
        par_en_d <= 0;
    end else begin
        par_en_d <= par_chk_en;

        if (par_chk_en && !par_en_d) begin
            par_acc <= 0;
            count   <= 0;
            par_err <= 0;
        end

        // DATA bits 
        else if (par_chk_en && count < w) begin
            par_acc <= par_acc ^ data_sam;
            count   <= count + 1;
        end

        // PARITY bit 
        else if (par_chk_en && count == w) begin
            par_err <= (par_acc ^ data_sam) ^ p_type;
            count <= count + 1;
        end
    end
end


endmodule

