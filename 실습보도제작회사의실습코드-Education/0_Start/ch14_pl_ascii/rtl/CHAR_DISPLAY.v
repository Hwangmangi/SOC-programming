`define LINE_CHAR_NUM	56    // Characters

module CHAR_DISPLAY
(
char_column,
char_line,
subchar_line,
subchar_pixel,
pixel_clock,
reset,
vga_red_data,
vga_green_data,
vga_blue_data
);

input [6:0]		char_column;		// character number on the current line
input [6:0]		char_line;			// line number on the screen
input [2:0]		subchar_line;		// the line number within a character block 0-8
input [2:0]		subchar_pixel;		// the pixel number within a character block 0-8
input				pixel_clock;
input				reset;
output			vga_red_data;
output			vga_green_data;
output			vga_blue_data;


//// Label Definitions ////

// Note: all labels must match their defined length--shorter labels will be padded with solid blocks,
// and longer labels will be truncated

//// 48 character label for the example text
//wire [0:8*52-1] example_text_line0 = "The RPS-3000 is a complete ASIC/SOC logic emulation,";
//wire [0:8*51-1] example_text_line1 = "prototyping and IP development/verification system.";
//wire [0:8*52-1] example_text_line2 = "The RPS-3000 base board is populated with one Xilinx";
//wire [0:8*48-1] example_text_line3 = "Virtex-5 LX330 FPGA, supporting peripherals, IO,"; 
//wire [0:8*23-1] example_text_line4 = "and power distribution.";
//wire [0:8*54-1] example_text_line5 = "Up to two additional LX330 modules can be plugged into";
//wire [0:8*46-1] example_text_line6 = "the high-speed connectors of the base board to"; 
//wire [0:8*54-1] example_text_line7 = "significantly extend the platform's FPGA gate density.";
//wire [0:8*58-1] example_text_line8 = "                                                          ";
//wire [0:8*48-1] example_text_line9 = "In addition to the ARM add-on Core Tile modules,";
//wire [0:8*44-1] example_text_line10= "the DVI, PCIe, Debug, ADC/DAC,Communication,";
//wire [0:8*52-1] example_text_line11= "and Multimedia modules are also available to further";
//wire [0:8*43-1] example_text_line12= "extend the flexibility and functionality of";
//wire [0:8*21-1] example_text_line13= "the RPS-3000 platform";

//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[0] = "The RPS-3000 is a complete ASIC/SOC logic emulation,    ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[1] = "prototyping and IP development/verification system.     ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[2] = "The RPS-3000 base board is populated with one Xilinx    ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[3] = "Virtex-5 LX330 FPGA, supporting peripherals, IO,        "; 
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[4] = "and power distribution.                                 ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[5] = "Up to two additional LX330 modules can be plugged into  ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[6] = "the high-speed connectors of the base board to          "; 
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[7] = "significantly extend the platform's FPGA gate density.  ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[8] = "                                                        ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[9] = "In addition to the ARM add-on Core Tile modules,        ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[10]= "the DVI, PCIe, Debug, ADC/DAC,Communication,            ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[11]= "and Multimedia modules are also available to further    ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[12]= "extend the flexibility and functionality of             ";
//wire [0:8*`LINE_CHAR_NUM-1] example_text_line[13]= "the RPS-3000 platform                                   ";

wire [0:8*`LINE_CHAR_NUM-1] example_text_line[0:32];

assign example_text_line[0][0:8*`LINE_CHAR_NUM-1] = "The RPS-3000 is a complete ASIC/SOC logic emulation,    ";
assign example_text_line[1][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[2][0:8*`LINE_CHAR_NUM-1] = "prototyping and IP development/verification system.     ";
assign example_text_line[3][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[4][0:8*`LINE_CHAR_NUM-1] = "The RPS-3000 base board is populated with one Xilinx    ";
assign example_text_line[5][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[6][0:8*`LINE_CHAR_NUM-1] = "Virtex-5 LX330 FPGA, supporting peripherals, IO,        "; 
assign example_text_line[7][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[8][0:8*`LINE_CHAR_NUM-1] = "and power distribution.                                 ";
assign example_text_line[9][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[10][0:8*`LINE_CHAR_NUM-1] = "Up to two additional LX330 modules can be plugged into  ";
assign example_text_line[11][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[12][0:8*`LINE_CHAR_NUM-1] = "the high-speed connectors of the base board to          "; 
assign example_text_line[13][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[14][0:8*`LINE_CHAR_NUM-1] = "significantly extend the platform's FPGA gate density.  ";
assign example_text_line[15][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[16][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[17][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[18][0:8*`LINE_CHAR_NUM-1] = "In addition to the ARM add-on Core Tile modules,        ";
assign example_text_line[19][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[20][0:8*`LINE_CHAR_NUM-1] = "the DVI, PCIe, Debug, ADC/DAC,Communication,            ";
assign example_text_line[21][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[22][0:8*`LINE_CHAR_NUM-1] = "and Multimedia modules are also available to further    ";
assign example_text_line[23][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[24][0:8*`LINE_CHAR_NUM-1] = "extend the flexibility and functionality of             ";
assign example_text_line[25][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[26][0:8*`LINE_CHAR_NUM-1] = "the RPS-3000 platform                                   ";
assign example_text_line[27][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[28][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[29][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[30][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[31][0:8*`LINE_CHAR_NUM-1] = "                                                        ";
assign example_text_line[32][0:8*`LINE_CHAR_NUM-1] = "                                                        ";

wire [13:0] 	char_addr = {char_line[6:0], char_column[6:0]};
wire				write_enable;			// character memory is written to on a clock rise when high
wire				pixel_on;				// high => output foreground color, low => output background color
reg [7:0] 		char_write_data;		// the data that will be written to character memory at the clock rise

wire direction;
wire [6:0] inter_char_line;
wire [6:0] inter_char_column;


integer			i;							// iterator

// always enable writing to character RAM
assign write_enable = 1;

assign direction = 1'b1;

assign inter_char_line = (direction) ? (7'h20 - char_line[6:0]) : char_line[6:0];
assign inter_char_column = (direction) ? (`LINE_CHAR_NUM - char_column[6:0]) : char_column[6:0];

// write the appropriate character data to memory
always @ (inter_char_line or inter_char_column) begin
	// insert a space by default
	char_write_data <= 8'h20;
	
		for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
			if (inter_char_column == i)
				char_write_data <= example_text_line[inter_char_line][i*8+:8];
		end
	
//	// write the example text to the first line
//   case (inter_char_line)
//	7'h00: begin
//		// write the example text starting at the first column
////		for (i = 0; i < 52; i = i + 1) begin
//		for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line0[i*8+:8];
//		end
//	end
//   7'h01: begin
////      for (i = 0; i < 51; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line1[i*8+:8];
//		end
//	end
//   7'h05: begin
////      for (i = 0; i < 52; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line2[i*8+:8];
//		end
//	end
//   7'h07: begin
////      for (i = 0; i < 48; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line3[i*8+:8];
//		end
//	end
//	7'h09: begin
//		// write the example text starting at the first column
////		for (i = 0; i < 23; i = i + 1) begin
//		for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line4[i*8+:8];
//		end
//	end
//   7'h0c: begin
////      for (i = 0; i < 54; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line5[i*8+:8];
//		end
//	end
//   7'h0e: begin
////      for (i = 0; i < 46; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line6[i*8+:8];
//		end
//	end
//   7'h10: begin
////      for (i = 0; i < 54; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line7[i*8+:8];
//		end
//	end
//   7'h12: begin
////      for (i = 0; i < 58; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line8[i*8+:8];
//		end
//	end
//   7'h14: begin
////      for (i = 0; i < 48; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line9[i*8+:8];
//		end
//	end
//   7'h16: begin
////      for (i = 0; i < 44; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line10[i*8+:8];
//		end
//	end
//   7'h18: begin
////      for (i = 0; i < 52; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line11[i*8+:8];
//		end
//	end
//   7'h1A: begin
////      for (i = 0; i < 43; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line12[i*8+:8];
//		end
//	end
//   7'h1C: begin
////      for (i = 0; i < 21; i = i + 1) begin
//      for (i = 0; i < `LINE_CHAR_NUM; i = i + 1) begin
//			if (inter_char_column == i)
//				char_write_data <= example_text_line13[i*8+:8];
//		end
//	end
//	default: begin end
//   endcase
end


reg				background_red;		// the red component of the background color
reg				background_green;		// the green component of the background color
reg				background_blue;		// the blue component of the background color
reg				foreground_red;		// the red component of the foreground color
reg				foreground_green;		// the green component of the foreground color
reg				foreground_blue;		// the blue component of the foreground color

// use the result of the character generator module to choose between the foreground and background color
assign vga_red_data = (pixel_on) ? foreground_red : background_red;
assign vga_green_data = (pixel_on) ? foreground_green : background_green;
assign vga_blue_data = (pixel_on) ? foreground_blue : background_blue;

// select the appropriate character colors
always @ (inter_char_line or inter_char_column) begin
	// always use a black background with white text
if ((inter_char_line == 7'h00) && ((inter_char_column >= 26) && (inter_char_column <= 34))) begin
	background_red <= 1'b0;
	background_green <= 1'b0;
	background_blue <= 1'b0;
	foreground_red <= 1'b0;
	foreground_green <= 1'b0;
	foreground_blue <= 1'b1;
   end
else if (((inter_char_line == 7'h00) || (inter_char_line == 7'h05) || (inter_char_line == 7'h1C)) &&
        ((inter_char_column >= 3) && (inter_char_column <= 11))) begin
	background_red <= 1'b0;
	background_green <= 1'b0;
	background_blue <= 1'b0;
	foreground_red <= 1'b0;
	foreground_green <= 1'b1;
	foreground_blue <= 1'b0;
   end
else begin
	background_red <= 1'b0;
	background_green <= 1'b0;
	background_blue <= 1'b0;
	foreground_red <= 1'b1;
	foreground_green <= 1'b1;
	foreground_blue <= 1'b1;
   end
end

// the character generator block includes the character RAM
// and the character generator ROM
CHAR_GEN CHAR_GEN
(
reset,				// reset signal
char_addr,			// write address
char_write_data,	// write data
write_enable,		// write enable
pixel_clock,		// write clock
char_addr,			// read address of current character
subchar_line,		// current line of pixels within current character
subchar_pixel,		// current column of pixels withing current character
pixel_clock,		// read clock
pixel_on				// read data
);

endmodule //CHAR_DISPLAY