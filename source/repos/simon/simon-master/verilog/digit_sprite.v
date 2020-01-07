module digit_sprite (
	input clk,
	input [8:0] xvga,
	input [7:0] yvga,
	input [3:0] number,
	
	output [2:0] color
	);
	// location of sprite digit
	parameter X_POS = 0;
	parameter Y_POS = 0;
	
	
	// address in ROM which we are referencing
	wire [3:0] x = xvga - X_POS;
	wire [3:0] y = yvga - Y_POS;
	
	// output from each digit's ROM
	wire [2:0] zero_col, one_col, two_col, three_col, four_col, five_col, six_col, seven_col, eight_col, nine_col;
	
	// select the digit we wants ROM
	mux_10x1 sprite_mux (
		.d0 (zero_col),
		.d1 (one_col),
		.d2 (two_col),
		.d3 (three_col),
		.d4 (four_col),
		.d5 (five_col),
		.d6 (six_col),
		.d7 (seven_col),
		.d8 (eight_col),
		.d9 (nine_col),
		.s  (number),
		.f  (color)
	);
	
	
	// declarations of each digit's sprite
	
	ROM_10x12 zero (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (zero_col)
	);
	defparam zero.IMAGE_FILE = "0.mem";
	
	ROM_10x12 one (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (one_col)
	);
	defparam one.IMAGE_FILE = "1.mem";
	
	ROM_10x12 two (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (two_col)
	);
	defparam two.IMAGE_FILE = "2.mem";
	
	ROM_10x12 three (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (three_col)
	);
	defparam three.IMAGE_FILE = "3.mem";
	
	ROM_10x12 four (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (four_col)
	);
	defparam four.IMAGE_FILE = "4.mem";
	
	ROM_10x12 five (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (five_col)
	);
	defparam five.IMAGE_FILE = "5.mem";
	
	ROM_10x12 six (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (six_col)
	);
	defparam six.IMAGE_FILE = "6.mem";
	
	ROM_10x12 seven (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (seven_col)
	);
	defparam seven.IMAGE_FILE = "7.mem";
	
	ROM_10x12 eight (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (eight_col)
	);
	defparam eight.IMAGE_FILE = "8.mem";
	
	ROM_10x12 nine (
		.clk (clk),
		.x		(x),
		.y		(y),
		.dout (nine_col)
	);
	defparam nine.IMAGE_FILE = "9.mem";

endmodule

	