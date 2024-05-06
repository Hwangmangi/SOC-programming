module tb_bcd_counter;
reg[4:0] i;

reg clk;
reg rst_n;

wire[3:0] q;

parameter PER100_100MHZ = 10;


bcd_counter U0 (.clk(clk),.rst_n(rst_n),.q(q));

always begin
    #( PER100_100MHZ/2) clk<=~clk;
end

initial begin
    i=5'd0;
    clk=1'b0;
    rst_n=1'b0;
    #( PER100_100MHZ+2);
    rst_n=1'b1;
    
    for(i=5'd0;i<5'd30; i=i+5'd1) begin
         #PER100_100MHZ;
    end
    $stop;
end
endmodule
