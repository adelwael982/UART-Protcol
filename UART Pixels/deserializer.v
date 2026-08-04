module deserializer #(parameter w = 8)(
    input clk,rst,deser_en,data_sam,
    output reg [w-1:0] p_data
);

reg [2:0] count;
reg deser_en_d;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        p_data     <= 0;
        count      <= 0;
        deser_en_d <= 0;
    end
     else begin
        deser_en_d <= deser_en;

        if (deser_en && !deser_en_d) begin
            
            p_data <= { {w-1{1'b0}}, data_sam };
            count  <= 0;
        end
        else if (deser_en && count < w) begin
            p_data <= { p_data[w-2:0], data_sam };
            count  <= count + 1;
        end
        else if (!deser_en) begin
            count<=0;
            deser_en_d<=0;
        end
    end
end


endmodule

