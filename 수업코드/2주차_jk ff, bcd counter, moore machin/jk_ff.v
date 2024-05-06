 module jk_ff(
 input wire clk,
 input wire rst_n,
 input wire j,
 input wire k,
 
 output reg q,
 output wire q_b);
 
 assign q_b=~q;
 
 always@(posedge clk or negedge rst_n)
 begin
 
    if(rst_n==1'b0) begin
        q<=1'b0;
        end
    else begin
        case({j,k})
            2'b00 : q<=q;
            2'b01 : q<=1'b0;
            2'b10 : q<=1'b1;
            2'b11 : q<=~q;
         endcase
     end
end
endmodule
