module CHAR_TOP
(
SYSTEM_CLOCK,
nSYSPOR,
SW,

LED,

VGA_HSYNCH,
VGA_VSYNCH,
LCD_R,
LCD_G,
LCD_B,
VGA_CLK,
VGA_EN,
lcd_blk_on//,
//lcd_nsync_vga,
//lcd_sync_t_vga,
);

input				SYSTEM_CLOCK;				// 100MHz LVTTL SYSTEM CLOCK
input          nSYSPOR;

input [2:0]		SW;							// switches

output [7:0]	LED;							// User LEDs

output 			VGA_HSYNCH;					// horizontal sync for the VGA output connector
output			VGA_VSYNCH;					// vertical sync for the VGA output connector
output [7:3] 	LCD_R;				// RED DAC data
output [7:2] 	LCD_G;				// GREEN DAC data
output [7:3] 	LCD_B;				// BLUE DAC data
output         VGA_CLK;
output         VGA_EN; // VGA Enable

output lcd_blk_on;
//output lcd_nsync_vga;
//output lcd_sync_t_vga;

wire				system_clock_buffered;	// buffered SYSTEM CLOCK
wire				pixel_clock;				// generated from SYSTEM CLOCK
wire				reset;						// reset asserted when DCMs are NOT LOCKED

wire				vga_red_data;				// red video data
wire				vga_green_data;			// green video data
wire				vga_blue_data;				// blue video data

wire           VGA_CLK;
wire           VGA_EN;
reg [7:0] LED;

// internal video timing signals
wire 				h_synch;						// horizontal synch for VGA connector
wire 				v_synch;						// vertical synch for VGA connector
wire 				blank;						// composite blanking
wire [10:0]		pixel_count;				// bit mapped pixel position within the line
wire [9:0]		line_count;					// bit mapped line number in a frame lines within the frame
wire [2:0]		subchar_pixel;				// pixel position within the character
wire [2:0]		subchar_line;				// identifies the line number within a character block
wire [6:0]		char_column;				// character number on the current line
wire [6:0]		char_line;					// line number on the screen

wire TEMP_HSYNCH;
wire TEMP_VSYNCH;
wire temp_reset;

wire VGA_OUT_RED;
wire VGA_OUT_GREEN;
wire VGA_OUT_BLUE;

assign lcd_blk_on = 1'b1;
//assign lcd_nsync_vga = 1'b1;
//assign lcd_sync_t_vga = 1'b1;
assign reset = ~nSYSPOR;

assign LCD_R[7:3] = (VGA_OUT_RED) ? 5'b11111 : 0;
assign LCD_G[7:2] = (VGA_OUT_GREEN) ? 6'b111111 : 0;
assign LCD_B[7:3] = (VGA_OUT_BLUE) ? 5'b11111 : 0;

always @ (posedge pixel_clock) begin
LED[0] <= SW[0]; // Turn LED 0 on when switch 0 is on
LED[1] <= SW[1]; // Turn LED 1 on when switch 1 is on
LED[2] <= SW[2]; // Turn LED 2 on when switch 2 is on
LED[3] <= SW[0]; // Turn LED 3 on when switch 3 is on
LED[4] <= SW[1]; // Turn LED 4 on when switch 4 is on
LED[5] <= SW[2]; // Turn LED 5 on when switch 5 is on
LED[6] <= SW[0]; // Turn LED 6 on when switch 6 is on
LED[7] <= SW[1]; // Turn LED 7 on when switch 7 is on
end

// instantiate the character generator
CHAR_DISPLAY CHAR_DISPLAY
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

// instantiate the clock generation module
CLOCK_GEN CLOCK_GEN 
(
SYSTEM_CLOCK,
system_clock_buffered,
pixel_clock,
temp_reset
//reset
);

// instantiate the video timing generator
SVGA_TIMING_GENERATION SVGA_TIMING_GENERATION
(
pixel_clock,
reset,
h_synch,
v_synch,
blank,
pixel_count,
line_count,
subchar_pixel,
subchar_line,
char_column,
char_line
);

// instantiate the video output mux
VIDEO_OUT VIDEO_OUT
(
pixel_clock,
reset,
vga_red_data,
vga_green_data,
vga_blue_data,
h_synch,
v_synch,
blank,

//VGA_HSYNCH,
//VGA_VSYNCH,
TEMP_HSYNCH,
TEMP_VSYNCH,
VGA_OUT_RED,
VGA_OUT_GREEN,
VGA_OUT_BLUE
);

assign VGA_HSYNCH = ~TEMP_HSYNCH;
assign VGA_VSYNCH = ~TEMP_VSYNCH;
assign VGA_EN = 1'b1;
assign VGA_CLK = ~pixel_clock;

endmodule // MAIN