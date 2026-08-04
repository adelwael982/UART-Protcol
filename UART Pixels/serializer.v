module serializer #(parameter w = 8)(
    input clk, rst, ser_en,
    input  [w-1:0] p_data,
    output reg ser_done, ser_data
);

reg [w-1:0] regi;
reg [2:0]   count;
reg ser_en_d;  // delay

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        regi     <= 0;
        count    <= 0;
        ser_data <= 1'b1;
        ser_done <= 1'b0;
        ser_en_d <= 0;
    end 
    else begin
        ser_done <= 1'b0;  // default pulse
        ser_en_d <= ser_en;
        
//to write this values only if its the first rising edge if not it ignores
        if (ser_en && !ser_en_d) begin
    regi     <= p_data;
    ser_data <= p_data[0];
    count    <= 1;
end
else if (ser_en) begin
    ser_data <= regi[1];
    regi     <= regi >> 1;  // shift right every cycle


            if (count == w-1) begin
                ser_done <= 1'b1;
                
            end
            else begin
                count <= count + 1;
            end
        end
    end
end

endmodule
