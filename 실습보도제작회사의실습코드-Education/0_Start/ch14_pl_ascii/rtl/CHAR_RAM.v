module CHAR_RAM
(
clka,
wea,
addra,
dia,

clkb,
addrb,
dob
);

input  clka;
input  wea;
input  [13:0] addra;
input  [7:0] dia;

input  clkb;
input  [13:0] addrb;
output [7:0] dob;

reg    [7:0] ram [16383:0];
reg    [13:0] read_addrb;

always @(posedge clka) begin
	if (wea)
		ram[addra] <= dia;
end

always @(posedge clkb) begin
	read_addrb <= addrb;
end

assign dob = ram[read_addrb];

// fill the character RAM with spaces
integer index;
integer index2;
initial begin
//	for (index = 0; index <= 16383; index = index + 1) begin
	for (index = 0; index <= 9999; index = index + 1) begin
		ram[index] = 8'h20; // ASCII space
	end
   for (index2 = 10000; index2 <= 16383; index2 = index2 + 1) begin
		ram[index2] = 8'h20; // ASCII space
   end	
end

endmodule //CHAR_RAM


