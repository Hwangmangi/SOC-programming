module bin2seg(
input	wire	[3:0]	bin,

output	reg		[7:0]	seg
);

always @(bin)
begin
	case(bin)
			4'b0000 : seg = 8'b0000_0011;
		4'b0001 : seg = 8'b1001_1111;
		4'b0010 : seg = 8'b0010_0101;
		4'b0011 : seg = 8'b0000_1101;
		
		4'b0100 : seg = 8'b1001_1001;
		4'b0101 : seg = 8'b0100_1001;
		4'b0110 : seg = 8'b0100_0001;
		4'b0111 : seg = 8'b0001_1011;
		
		4'b1000 : seg = 8'b0000_0001;
		4'b1001 : seg = 8'b0001_1001;
		4'b1010 : seg = 8'b1111_1101;
		default : seg = 8'b1111_1111;
	endcase
end

endmodule
