module color_selector (
	input clk,
	input [8:0] xvga,
	input [7:0] yvga,
	input [3:0] level_10, level_01, max_score_10, max_score_01,
	input [2:0] bg,
	output reg [2:0] color
	);
	// boundary parameters
	parameter WIDTH = 10;
	parameter HEIGHT = 12;
	parameter LEVEL_10_X = 70;
	parameter LEVEL_01_X = 80;
	parameter MAX_SCORE_10_X = 280;
	parameter MAX_SCORE_01_X = 290;
	parameter Y = 3;
	
	// on one of main screens
	wire on_main = (bg >= 1 && bg <= 5);
	
	// sprite boundaries demarcation
	wire in_level_10_delayed 		= (on_main) && (xvga >= LEVEL_10_X) && (xvga < LEVEL_10_X+WIDTH) && (yvga >= Y) && (yvga < Y+HEIGHT);
	wire in_level_01_delayed 		= (on_main) && (xvga >= LEVEL_01_X) && (xvga < LEVEL_01_X+WIDTH) && (yvga >= Y) && (yvga < Y+HEIGHT);
	wire in_max_score_10_delayed	= (on_main) && (xvga >= MAX_SCORE_10_X) && (xvga < MAX_SCORE_10_X+WIDTH) && (yvga >= Y) && (yvga < Y+HEIGHT);
	wire in_max_score_01_delayed	= (on_main) && (xvga >= MAX_SCORE_01_X) && (xvga < MAX_SCORE_01_X+WIDTH) && (yvga >= Y) && (yvga < Y+HEIGHT);
	
	// delay demarcation
	reg in_level_10, in_level_01, in_max_score_10, in_max_score_01;
	always @(posedge clk) begin
		in_level_10 <= in_level_10_delayed;
		in_level_01 <= in_level_01_delayed;
		in_max_score_10 <= in_max_score_10_delayed;
		in_max_score_01 <= in_max_score_01_delayed;
	end
	
	// select which pixel color to use (depending on whether or not it is within sprite boundaries)
	wire [3:0] select = {in_level_10, in_level_01, in_max_score_10, in_max_score_01};
	
	
	wire [2:0] max_score_01_color, max_score_10_color, level_01_color, level_10_color;
	wire [2:0] bg0_color, bg1_color, bg2_color, bg3_color, bg4_color, bg5_color, bg6_color, bg7_color, bg_col;
	
	reg [2:0] delayed_color;
	
	// switch between pixel color
	always @(*)
		case (select)
			4'b0000: color = bg_col;
			4'b0001: color = max_score_01_color;
			4'b0010: color = max_score_10_color;
			4'b0100: color = level_01_color;
			4'b1000: color = level_10_color;
			default: color = 3'b100;
		endcase
	
	

		
	
	// ******************
	// SPRITES
	// ******************
	
	digit_sprite level_10_sprite (
		.clk (clk),
		.xvga (xvga),
		.yvga (yvga),
		.number (level_10),
		.color (level_10_color)
	);
	defparam level_10_sprite.X_POS = LEVEL_10_X;
	defparam level_10_sprite.Y_POS = Y;
	
	
	digit_sprite level_01_sprite (
		.clk (clk),
		.xvga (xvga),
		.yvga (yvga),
		.number (level_01),
		.color (level_01_color)
	);
	defparam level_01_sprite.X_POS = LEVEL_01_X;
	defparam level_01_sprite.Y_POS = Y;
	
	digit_sprite max_score_10_sprite (
		.clk (clk),
		.xvga (xvga),
		.yvga (yvga),
		.number (max_score_10),
		.color (max_score_10_color)
	);
	defparam max_score_10_sprite.X_POS = MAX_SCORE_10_X;
	defparam max_score_10_sprite.Y_POS = Y;
	
	
	digit_sprite max_score_01_sprite (
		.clk (clk),
		.xvga (xvga),
		.yvga (yvga),
		.number (max_score_01),
		.color (max_score_01_color)
	);
	defparam max_score_01_sprite.X_POS = MAX_SCORE_01_X;
	defparam max_score_01_sprite.Y_POS = Y;
	
	
	
	// ******************
	// BACKGROUND IMAGES
	// ******************
	
	bg_mux bg_mux (
		.bg0_color (bg0_color),
		.bg1_color (bg1_color),
		.bg2_color (bg2_color),
		.bg3_color (bg3_color),
		.bg4_color (bg4_color),
		.bg5_color (bg5_color),
		.bg6_color (bg6_color),
		.bg7_color (bg7_color),
		.bg		  (bg),
		.color	  (bg_col)
	);
	
	ROM_320x240 home_screen (
		.clk (clk),
		.x 	(xvga),
		.y		(yvga),
		.dout	(bg0_color)
	);
	defparam home_screen.IMAGE_FILE = "home.mem";
	
	ROM_320x240 default_screen (
		.clk 	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg1_color)
	);
	defparam default_screen.IMAGE_FILE = "default.mem";
	
	ROM_320x240 green_screen (	
		.clk	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg2_color)
	);
	defparam green_screen.IMAGE_FILE = "green.mem";
	
	ROM_320x240 red_screen (
		.clk	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg3_color)
	);
	defparam red_screen.IMAGE_FILE = "red.mem";
	
	ROM_320x240 yellow_screen (
		.clk	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg4_color)
	);
	defparam yellow_screen.IMAGE_FILE = "yellow.mem";
	
		
	ROM_320x240 blue_screen (
		.clk	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg5_color)
	);
	defparam blue_screen.IMAGE_FILE = "blue.mem";
	
	ROM_320x240 fail_screen (
		.clk	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg6_color)
	);
	defparam fail_screen.IMAGE_FILE = "fail.mem";
	
	ROM_320x240 win_screen (
		.clk	(clk),
		.x		(xvga),
		.y		(yvga),
		.dout	(bg7_color)
	);
	defparam win_screen.IMAGE_FILE = "win.mem";


endmodule
