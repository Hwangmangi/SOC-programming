module top(
input	wire			resetn,
input	wire			clk,

output	wire	[7:0]	seg_en,
output	wire	[7:0]	seg_data,
output	wire			lcd_rs,
output	wire			lcd_rw,
output	wire			lcd_en,
output	wire	[7:0]	lcd_data
);

wire	[31:0]	segdata;
wire	[31:0]	textdata_a;
wire	[31:0]	textdata_b;
wire	[31:0]	textdata_c;
wire	[31:0]	textdata_d;
wire	[31:0]	textdata_e;
wire	[31:0]	textdata_f;
wire	[31:0]	textdata_g;
wire	[31:0]	textdata_h;


// Coding here!

seven_seg t0(
.resetn(resetn),
.clk(clk),
.data(segdata), 

.seg_en(seg_en), 
.seg_data(seg_data)
);

textlcd t1(
.resetn(resetn),			
.clk(clk),			
.reg_a(textdata_a),
.reg_b(textdata_b),
.reg_c(textdata_c),
.reg_d(textdata_d),
.reg_e(textdata_e),
.reg_f(textdata_f),
.reg_g(textdata_g),
.reg_h(textdata_h),
	
.lcd_rs(lcd_rs),			
.lcd_rw(lcd_rw),			
.lcd_en(lcd_en),			
.lcd_data(lcd_data)		
);

digital_clock t2(
.resetn(resetn),
.clk(clk),		

.segdata(segdata),
.textdata_a(textdata_a),
.textdata_b(textdata_b),
.textdata_c(textdata_c),
.textdata_d(textdata_d),
.textdata_e(textdata_e),
.textdata_f(textdata_f),
.textdata_g(textdata_g),
.textdata_h(textdata_h)
);




endmodule

