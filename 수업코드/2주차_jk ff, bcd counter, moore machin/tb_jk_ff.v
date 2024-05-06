`timescale 1ns / 1ps


module tb_jk_ff;
    
    reg [2:0] i;
    reg clk;
    reg rst_n;
    reg j;
    reg k;
    
    wire q;
    wire q_b;
    
    parameter PER100_100MHZ = 10;
    
     jk_ff J1(.clk(clk), .rst_n(rst_n), .j(j), .k(k), .q(q), .q_b(q_b));
     
     always 
     #(PER100_100MHZ/2) clk<=~clk;
     
     initial begin
        i=3'd0;
        clk=1'b0;
        rst_n=1'b0;
        j=1'b0;
        k=1'b0;
        #(PER100_100MHZ+2);
        rst_n=1'b1;
        
        for(i=3'd0;i<=3'd3;i=i+3'd1) begin
            j=i[1];
            k=i[0];
            #PER100_100MHZ;
        end
        
        #PER100_100MHZ;
        
        rst_n=1'b0;
        #(PER100_100MHZ+2)
        
        $stop;
    end       
endmodule
