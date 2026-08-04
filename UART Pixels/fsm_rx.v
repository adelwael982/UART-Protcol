module fsm_rx (
   input clk,rst,par_err,stop_err,par_en,rx_in,
   input [3:0] bit_cnt,
   output reg par_chk_en,stop_en,enable,deser_en,data_valid
);
reg [2:0] cs,ns;
localparam 
s0='b000, //idle
s1='b001, //serial data
s2='b010, //parity error
s3='b011,
s4='b100; //stop error
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cs<=s0;
    end
    else begin
        cs<=ns;
    end
end
always @(*) begin
   ns = cs;

    enable = 0;
    deser_en = 0;
    data_valid = 0;
    par_chk_en = 0;
    stop_en = 0;
    case(cs)
     s0:begin
        if (!rx_in) begin
            ns=s1;enable=1;par_chk_en=1;
        end
        else begin
            ns=s0;
        end
     end
     s1:begin
          deser_en=1;enable=1;par_chk_en=1;
          if(bit_cnt==8) begin
            if (par_en) begin
                ns=s2;
            end
            else begin
                ns=s3;
            end
        end
        else begin
            ns=s1;
        end
     end
     s2:begin
        enable=1;par_chk_en=1;
      if (par_err) begin
        ns=s0;
      end
      else begin
        ns=s3;
      end
     end
     s3:begin
       enable=1;stop_en=1;
        if(stop_err&&(bit_cnt==8||bit_cnt==9)) begin
         ns=s0;
     end
     else if (stop_err&&(!(bit_cnt==8||bit_cnt==9))) begin
        ns=s3;
     end
     else  begin
        ns=s4;
     end
     end
     s4:begin
       if(!stop_err&&!par_err) begin
        ns=s0;data_valid=1;
       end 
       else begin
        ns=s0;
       end
     end
     default : ns=s0; 
endcase    
end
endmodule
