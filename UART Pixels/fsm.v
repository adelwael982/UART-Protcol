module fsm(
     input clk,rst,par_en,data_valid,ser_done,
     output reg busy,ser_en,
     output  [1:0] mux_sel
);
reg [1:0] cs,ns;
localparam 
s0=2'b00, //stop bit
s1=2'b01, //start bit
s2=2'b10, //serial
s3=2'b11 //parity
;
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cs<=s0;
    end
    else begin
        cs<=ns;
    end
end
always @(*) begin
    ns=cs;
    busy = (cs != s0);
    ser_en=1'b0;
    case (cs)
    s0 : begin
        if(data_valid) begin
        ns=s1;
    end
     else begin
        ns=s0; busy = (cs != s0);
    end
    end 
    s1 :begin
          ns=s2; ser_en=1'b1;
    end
    s2 : begin
        ser_en=1'b1;
        if (ser_done) begin
            if (par_en) begin
                ns=s3;
            end
            else begin
                ns=s0;
            end
        end
        else begin
            ns=s2;
        end
    end
    s3 : begin
        ns=s0;
    end
        default: begin
            ns=s0; busy = (cs != s0);
        end
    endcase
end
assign mux_sel=cs;
endmodule